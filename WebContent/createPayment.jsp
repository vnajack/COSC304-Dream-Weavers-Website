<%@ include file="header.jsp"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
<html>
<head>
<title>Payment Information</title>
</head>

<h3>Please fill-in the following fields to place your order:</h3>

<form name="paymentInfo" method=post action="insertPayment.jsp" autocomplete="off">
	<table>
		<tr>
			<th><label for="paymentType">Payment Type: </label></th>
			<td><input type="radio" name="paymentType" value="American Express" checked>American Express
			<br><input type="radio" name="paymentType" value="Visa">Visa
			<br><input type="radio" name="paymentType" value="MasterCard">MasterCard
			<br></td>
		</tr>
		<tr>
			<th><label for="paymentNumber">Payment Number: </label></th>
			<td><input required type="text" name="paymentNumber" size=40
				placeholder="Please enter your credit card number"
				pattern="[0-9]{13,19}"
				title="Digits only, between 13 and 16 digits long."></td>
		</tr>
		<tr>
			<th><label for='paymentExpiryDate'>Expiry Date: </label></th>
			<td>
		<%
			Date date = new Date(System.currentTimeMillis());
			SimpleDateFormat dateFormatter = new SimpleDateFormat("YYYY-MM-dd");

			out.print(
					"<input type='date' name='paymentExpiryDate' min=" + dateFormatter.format(date) + " required>");
		%>
			</td>
		</tr>
	</table>
	<input class="submit" type="submit" name="Submit4" value="Next">

</form>
</html>