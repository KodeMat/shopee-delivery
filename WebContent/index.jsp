<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - Java 8 Web Application</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #080b11;
            --card-bg: rgba(255, 255, 255, 0.02);
            --card-border: rgba(255, 255, 255, 0.07);
            --primary-glow: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --accent-glow: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --text-primary: #f9fafb;
            --text-secondary: #9ca3af;
            --text-accent: #818cf8;
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        body {
            background-color: var(--bg-color);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            position: relative;
        }
        body::before {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.1) 0%, rgba(0,0,0,0) 70%);
            top: -150px;
            left: calc(50% - 300px);
            z-index: 0;
        }
        .container {
            max-width: 680px;
            width: 90%;
            z-index: 10;
            padding: 40px 0;
            text-align: center;
        }
        .logo-container {
            margin-bottom: 24px;
            display: inline-flex;
            justify-content: center;
            align-items: center;
            width: 80px;
            height: 80px;
            border-radius: 24px;
            background: rgba(99, 102, 241, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.25);
            color: var(--text-accent);
            font-size: 2.2rem;
            font-weight: 700;
            box-shadow: 0 8px 30px rgba(99, 102, 241, 0.15);
        }
        .title {
            font-size: 2.75rem;
            font-weight: 700;
            background: linear-gradient(135deg, #ffffff 30%, #c7d2fe 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.03em;
            margin-bottom: 12px;
        }
        .subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 36px;
        }
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--card-border);
            border-radius: 28px;
            padding: 36px;
            box-shadow: 0 20px 40px 0 rgba(0, 0, 0, 0.3);
            text-align: left;
            margin-bottom: 30px;
        }
        .section-title {
            font-size: 1.15rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            color: var(--text-accent);
            margin-bottom: 16px;
        }
        .route-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(255, 255, 255, 0.01);
            border: 1px solid rgba(255, 255, 255, 0.04);
            border-radius: 18px;
            padding: 18px 24px;
            margin-bottom: 12px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: inherit;
        }
        .route-item:hover {
            transform: translateY(-2px);
            background: rgba(99, 102, 241, 0.04);
            border-color: rgba(99, 102, 241, 0.2);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        .route-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .route-path {
            font-family: monospace;
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--text-primary);
        }
        .route-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }
        .badge {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            padding: 4px 10px;
            border-radius: 6px;
            letter-spacing: 0.05em;
        }
        .badge-servlet {
            background: rgba(99, 102, 241, 0.15);
            color: #a5b4fc;
            border: 1px solid rgba(99, 102, 241, 0.3);
        }
        .badge-jsp {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }
        .footer-note {
            font-size: 0.8rem;
            color: #4b5563;
            letter-spacing: 0.02em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo-container">
            J
        </div>
        <h1 class="title">Java Web Application</h1>
        <p class="subtitle">Scaffolded with native IntelliJ IDEA enterprise directory structure (src/ and web/).</p>
        
        <div class="glass-card">
            <h2 class="section-title">Available Routes</h2>
            
            <a href="login.jsp" class="route-item">
                <div class="route-info">
                    <span class="route-path">Logistics Portal / Login</span>
                    <span class="route-desc">Access the parcel delivery system as Admin or Supervisor.</span>
                </div>
                <span class="badge badge-servlet">System Login</span>
            </a>

            <a href="signup.jsp" class="route-item">
                <div class="route-info">
                    <span class="route-path">Request Access / Sign Up</span>
                    <span class="route-desc">Submit a supervisor registration request.</span>
                </div>
                <span class="badge badge-jsp">Registration</span>
            </a>
            
            <a href="hello" class="route-item">
                <div class="route-info">
                    <span class="route-path">/hello</span>
                    <span class="route-desc">Diagnostic Servlet showing JVM version, OS details, and server variables.</span>
                </div>
                <span class="badge badge-servlet">Servlet</span>
            </a>
        </div>
        
        <p class="footer-note">
            Current Server Time: <%= new java.util.Date() %><br>
            Package Prefix: <code>edu.iacademy.cselec05.pm_rima</code>
        </p>
    </div>
</body>
</html>
