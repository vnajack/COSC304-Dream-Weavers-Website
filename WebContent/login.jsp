<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Login Screen</title>
	</head>
	<body>
	<div style="margin:0 auto;text-align:center;display:inline">
	
		<h3>Please Log in to the Dream Vine</h3>
		
		<%
		// Print prior error login message if present
		if (session.getAttribute("loginMessage") != null)
			out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
		%>
		
		<br>
		<form name="MyForm" method=post action="validateLogin.jsp" autocomplete="off">
		<table style="display:inline">
			<tr>
				<td><div style="text-align:right;size:2;color:white">User id:</div></td>
				<td><input type="text" name="username"  size=10 maxlength=10></td>
			</tr>
			<tr>
				<td><div style="text-align:right;size:2;color:white">Password:</div></td>
				<td><input type="password" name="password" size=10 maxlength="10"></td>
			</tr>
		</table>
		<br/>
		<input class="submit" type="submit" name="Submit2" value="Log In">
		</form>
	</div>
	</body>
</html>

