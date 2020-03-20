<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<title>Dream Weavers Main Page</title>
<body>
<%
String username=(String)session.getAttribute("authenticatedUser");
out.print("<h1>Welcome");

if(username!=null){
	getConnection();
	
	String sql =  "SELECT firstName "
			+ "FROM customer "
			+ "WHERE userId = ?";

	try(PreparedStatement pstm = con.prepareStatement(sql);){
		pstm.setString(1, username);
		ResultSet rst = pstm.executeQuery();
		while(rst.next())
			out.print(", " + rst.getString("firstName") + ",");
		
	}catch(SQLException e){
		out.print("<p>Error. " + e + "</p>");
	}
}
out.print(" to the Dream Vine</h1>"
		+ "<div class=\"wrapper\" style=\"text-align:center\">");

//if(username==null){
//	out.print("<button onclick=\"window.location.href=\'login.jsp\'\">Login</button> "
//			+ "<button onclick=\"window.location.href=\'createCustomer.jsp\'\">Create an Account</button>");
//}else{
//	out.print("<button onclick=\"window.location.href=\'logout.jsp\'\">Log Out</button>");
//}
out.print("</div>");

%>
<p style="text-align:center"><i>There are 24 hours in a day, and we help ensure no hour of any day goes to waste.</i></p>

<h3 style="text-decoration:underline;text-align:left">About Us</h3>
<p>Founded in 2019 by the MetaDreamers, the Dream Weavers' mission is to sell the widest variety and highest quality of dreams to all people across the globe and to deliver them within 2 hours of purchase using our efficient and sustainable delivery system so that every person can enjoy every hour of every day.</p>

</body>
</head>


