<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Create an Account</title>
	</head>
	<h1>Create an Account</h1>
	<h4 style="color:white">Already have an account? Click 'Log in' to access your account</h4>
	<button onclick="window.location.href='login.jsp'">Log in</button>	
	<br>
	<h3>Please fill-in the following fields to create your account on the Dream Vine:</h3>
	<p style="text-align: center">All fields marked with an asterisk (*) are required.</p>
	<%
	if(session.getAttribute("createUserMessage") != null)
		out.print("<h3 style='color:red'>"+session.getAttribute("createUserMessage").toString()+"</p>");
	%>
	<form name="MyForm2" method=post action="validateCustomer.jsp" autocomplete="off">
		<table>
			<tr>
				<th><label for="username">User id*: </label></th>
				<td><input required type="text" name="username" size=40 placeholder="Choose a user id (this cannot be changed later!)" pattern="[a-zA-Z0-9]+" title="Can only contain letters and numbers. No punctuation or special characters."></td>
			</tr>
			<tr>
				<th><label for="password">Password*: </label></th>
				<td><input required type="password" name="password" size=40 placeholder="Choose a secure password" pattern=".{6,}" title="Your password must contain 6 or more characters"></td>
			</tr>
			<tr>
				<th><label for="firstName">First Name*: </label></th>
				<td><input required type="text" name="firstName" size=40 placeholder="Your first name" pattern="[a-zA-Z- ]+" title="Can only contain letters, hyphens, and spaces."></td>
			</tr>
			<tr>	
				<th><label for="lastName">Last Name*: </label></th>
				<td><input required type="text" name="lastName" size=40 placeholder="Your last name" pattern="[a-zA-Z- ]+" title="Can only contain letters, hyphens, and spaces."></td>
			</tr>
			<tr>
				<th><label for="email">Email*: </label></th>
				<td><input required type="text" name="email" size=40 placeholder="Your email address" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Must contain characters before and after '@' and at least two characters after '.'"></td>
			</tr>
			<tr>
				<th><label for="phonenum">Phone Number: </label></th>
				<td><input type="text" name="phonenum" size=40 placeholder="XXX-XXX-XXXX" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" title="Must be a 10-digit phone number in the format 123-456-7890"></td>
			</tr>
			<tr>
				<th><label for="address">Street Address: </label></th>
				<td><input type="text" name="address" size=40 placeholder="Your street address" pattern="[a-zA-Z0-9- ]+" title="Can only contain letters, numbers, hyphens, and spaces."></td>
			</tr>
			<tr>
				<th><label for="city">City: </label></th>
				<td><input type="text" name="city" size=40 placeholder="City" pattern="[a-zA-Z- ]+" title="Can only contain letters, hyphens, and spaces"></td>
			</tr>
			<tr>
				<th><label for="state">Province/State: </label></th>
				<td><input type="text" name="state" size=40 placeholder="Province or State" title="Province or State" pattern="[a-zA-Z- ]+" title="Can only contain letters, hyphens, and spaces"></td>
			</tr>
			<tr>
				<th><label for="postalCode">Postal Code: </label></th>
				<td><input type="text" name="postalCode" size=40 placeholder="Your postal code or zip code" pattern="[a-zA-Z0-9- ]{5,10}" title="Must be 5-10 characters long and can only contain letters, numbers, hyphens, and spaces"></td>
			</tr>
			<tr>
				<th><label for="country">Country: </label></th>
				<td><input type="text" name="country" size=40 placeholder="Country" pattern="[a-zA-Z- ]+" title="Can only contain letters, hyphens, and spaces"></td>
			</tr>
		</table>
		<input class="submit" type="submit" name="Submit3" value="Create Account">
		
	</form>
</html>