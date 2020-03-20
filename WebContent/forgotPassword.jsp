<!DOCTYPE html>
<html>
	<head>
		<title>Forgot Password</title>
	</head>
	<body background="twinklingStars.gif">
		<p style="text-align:center">
			<a href="index.jsp">
				<img src="shopLogo.png" alt="Logo" style="width:350px;height:280px;">
			</a>
		</p>
	<div style="margin:0 auto;text-align:center;display:inline">
	
		<h3 style="font-family:Comic sans MS;color:white">Please Login to System</h3>
		
		<%
		// Print prior error login message if present
		if (session.getAttribute("userName") != null) {
			out.println("<p style='color:white;font-family:Comic sans MS'>"+session.getAttribute("userNameMessage").toString()+"</p>");
		}
		%>
		<div class="wrapper" style="text-align:center">
		<button style="font-family:Comic sans MS" onclick="window.location.href='createCustomer.jsp'">Create Account</button>
		</div>
		
		<br>
		<form name="MyForm" method=post action="validateLogin.jsp">
		<table style="display:inline">
			<tr>
				<td><div style="text-align:right;font-family:Comic sans MS;size:2;color:white">User id:</div></td>
				<td><input type="text" name="username"  size=10 maxlength=10></td>
			</tr>
			<tr>
				<td><div style="text-align:right;font-family:Comic sans MS;size:2;color:white">Password:</div></td>
				<td><input type="password" name="password" size=10 maxlength="10"></td>
			</tr>
		</table>
		<br/>
		<input class="submit" type="submit" name="Submit2" value="Log In" style="font-family:Comic sans MS">
		</form>
	</div>
	</body>
</html>

