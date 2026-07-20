{ pkgs, lib, config, inputs, ... }:

{
  # 1. Force Java 1.8 (Java 8) as the environment runtime
  languages.java = {
    enable = true;
    jdk.package = pkgs.openjdk8; 
  };

  # 2. Pull Apache Tomcat 9 into the environment packages
  packages = [
    pkgs.tomcat9
  ];

  # 3. Automate environment paths for Catalina 
  env = {
    CATALINA_HOME = "${pkgs.tomcat9}";
    # Sets up a local writable workspace inside your project folder
    CATALINA_BASE = "${toString ./.}/.tomcat";
  };

  # 4. Custom build, package, and deploy script
  scripts.build.exec = ''
    # Compile Java files using native javac with Tomcat dependencies
    echo "Compiling Java sources..."
    mkdir -p web/WEB-INF/classes
    find src -name "*.java" > sources.txt
    if [ -s sources.txt ]; then
      javac -cp "$CATALINA_HOME/lib/servlet-api.jar:$CATALINA_HOME/lib/jsp-api.jar" -d web/WEB-INF/classes @sources.txt
    fi
    rm -f sources.txt

    # Stage web application layout
    echo "Staging application..."
    mkdir -p out/staging
    cp -rf web/* out/staging/
    rm -f out/staging/WEB-INF/lib/servlet-api.jar out/staging/WEB-INF/lib/jsp-api.jar

    # Package as WAR using JDK jar command
    echo "Packaging WAR file..."
    cd out/staging
    jar cf ../shopee-delivery.war *
    cd ../..

    # Deploy the WAR to local Tomcat server
    echo "Deploying to local Tomcat server..."
    mkdir -p "$CATALINA_BASE/webapps"
    cp -f out/shopee-delivery.war "$CATALINA_BASE/webapps/ROOT.war"
    echo "Build completed!"
  '';

  # 5. Automatically scaffold and boot Tomcat as a background service
  processes.tomcat.exec = ''
    # Scaffold CATALINA_BASE if conf doesn't exist yet
    if [ ! -d "$CATALINA_BASE/conf" ]; then
      mkdir -p "$CATALINA_BASE"/{conf,logs,webapps,work,temp}
      cp -rf $CATALINA_HOME/conf/* $CATALINA_BASE/conf/
    fi

    # Compile and deploy using the registered build script
    build
    
    # Run Tomcat in the foreground inside this process manager
    exec $CATALINA_HOME/bin/catalina.sh run
  '';
}

