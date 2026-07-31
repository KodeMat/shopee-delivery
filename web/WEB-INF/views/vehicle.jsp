<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vehicle Management</title>

<style>

body{
    font-family: Arial, Helvetica, sans-serif;
    background:#f2f2f2;
}

.container{
    width:900px;
    margin:30px auto;
    background:#fff;
    padding:20px;
    border-radius:8px;
    box-shadow:0px 0px 10px #ccc;
}

h2{
    text-align:center;
}

table{
    width:100%;
    border-collapse:collapse;
}

td,th{
    padding:10px;
}

input[type=text],
input[type=number],
select{

    width:100%;
    padding:8px;
}

button{

    padding:8px 15px;
    border:none;
    cursor:pointer;
    color:white;
}

.add{
    background:green;
}

.update{
    background:#007bff;
}

.reset{
    background:gray;
    color:white;
}

.listTable{

    margin-top:20px;
}

.listTable th{

    background:#333;
    color:white;
}

.listTable td{

    border:1px solid #ccc;
    text-align:center;
}

.success{

    color:green;
    text-align:center;
}

.error{

    color:red;
    text-align:center;
}

a{

    text-decoration:none;
}

</style>

</head>

<body>

<div class="container">

<h2>Vehicle Management</h2>

<%

if(request.getParameter("success")!=null){

%>

<p class="success">Operation Successful!</p>

<%

}

if(request.getParameter("error")!=null){

%>

<p class="error">Something went wrong!</p>

<%

}

%>

<form action="VehicleServlet" method="post">

<input type="hidden"
name="vehicleId"
value="<%=request.getParameter("vehicleId")==null?"":request.getParameter("vehicleId")%>">

<table>

<tr>

<td>Plate Number</td>

<td>

<input type="text"

name="plateNumber"

value="<%=request.getParameter("plateNumber")==null?"":request.getParameter("plateNumber")%>"

required>

</td>

</tr>

<tr>

<td>Vehicle Type</td>

<td>

<select name="vehicleType">

<option>Van</option>

<option>Truck</option>

<option>Motorcycle</option>

</select>

</td>

</tr>

<tr>

<td>Brand</td>

<td>

<input type="text"

name="brand"

value="<%=request.getParameter("brand")==null?"":request.getParameter("brand")%>">

</td>

</tr>

<tr>

<td>Model</td>

<td>

<input type="text"

name="model"

value="<%=request.getParameter("model")==null?"":request.getParameter("model")%>">

</td>

</tr>

<tr>

<td>Capacity</td>

<td>

<input type="number"

name="capacity"

value="<%=request.getParameter("capacity")==null?"":request.getParameter("capacity")%>">

</td>

</tr>

<tr>

<td>Status</td>

<td>

<select name="status">

<option>Available</option>

<option>Unavailable</option>

<option>Maintenance</option>

</select>

</td>

</tr>

<tr>

<td colspan="2" align="center">

<button

class="add"

type="submit"

name="action"

value="add">

Add Vehicle

</button>

<button

class="update"

type="submit"

name="action"

value="edit">

Update Vehicle

</button>

<input

class="reset"

type="reset"

value="Clear">

</td>

</tr>

</table>

</form>

<hr>

<h2>Vehicle List</h2>

<table class="listTable">

<tr>

<th>ID</th>
<th>Plate Number</th>
<th>Type</th>
<th>Brand</th>
<th>Model</th>
<th>Capacity</th>
<th>Status</th>
<th>Action</th>

</tr>

<%

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

<%-- Connect the MySQL database --%>
con=DriverManager.getConnection(

"",

"",

""

);

ps=con.prepareStatement("SELECT * FROM vehicles");

rs=ps.executeQuery();

while(rs.next()){

%>

<tr>

<td><%=rs.getInt("vehicle_id")%></td>

<td><%=rs.getString("plate_number")%></td>

<td><%=rs.getString("vehicle_type")%></td>

<td><%=rs.getString("brand")%></td>

<td><%=rs.getString("model")%></td>

<td><%=rs.getInt("capacity")%></td>

<td><%=rs.getString("status")%></td>

<td>

<a href="vehicle.jsp?vehicleId=<%=rs.getInt("vehicle_id")%>&plateNumber=<%=rs.getString("plate_number")%>&vehicleType=<%=rs.getString("vehicle_type")%>&brand=<%=rs.getString("brand")%>&model=<%=rs.getString("model")%>&capacity=<%=rs.getInt("capacity")%>&status=<%=rs.getString("status")%>">

Edit

</a>

|

<a href="VehicleServlet?action=delete&vehicleId=<%=rs.getInt("vehicle_id")%>"

onclick="return confirm('Delete this vehicle?');">

Delete

</a>

</td>

</tr>

<%

}

}catch(Exception e){

out.println(e);

}finally{

try{

if(rs!=null)rs.close();

if(ps!=null)ps.close();

if(con!=null)con.close();

}catch(Exception e){}

}

%>

</table>

</div>

</body>

</html>