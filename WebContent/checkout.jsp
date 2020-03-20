<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Dream Vine CheckOut</title>
</head>
<body>
<h1>Dream Vine CheckOut</h1>
<h3 style="text-align:center">Enter your customer id and password to complete the transaction:</h3>
	<%
		// Print prior error login message if present
		if (session.getAttribute("IDMessage") != null)
			out.println("<p>"+session.getAttribute("IDMessage").toString()+"</p>");
		%>
<form method="get" action="validateId.jsp" autocomplete="off">
<table>
<tr><td>Customer ID:</td><td><input type="text" name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
<tr><td></td><td><input type="submit" value="Submit"> <input type="reset" value="Reset"></td></tr>
</table>
</form>
</body>
</html>

