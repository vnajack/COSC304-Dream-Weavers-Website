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

<%
	try { // Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	// Connection Info
	String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
	String uid = "vjack";
	String pw = "12304986";

	Integer custId = (Integer) session.getAttribute("authenticatedId");

	try (Connection con = DriverManager.getConnection(url, uid, pw); Statement stmt = con.createStatement();) {
		//customerId=Integer.parseInt(custId); //custId is converted to int
		String sql = "SELECT paymentType, paymentNumber, paymentExpiryDate FROM paymentmethod WHERE customerId = ?;"; //query to obtain previous payment information from that customer
		PreparedStatement pstm = con.prepareStatement(sql); //create preparedstatement
		pstm.setInt(1, custId); //fill in ?
		ResultSet rst = pstm.executeQuery(); // get resultset
		if (!rst.next()) {
			response.sendRedirect("createPayment.jsp"); //occurs when the customer does not have an account associated with their id
		} else {
			out.print("<h1>Choose a Payment Method</h1>"
					+ "<h3 style='text-align:center'>We found the following payment method(s) associated with your account.<br> Would you like to pay using this information again?</h3>"
					+ "<button onclick=\"window.location.href=\'createPayment.jsp\'\">No, pay with another card</button><br><br>"
					+ "<table>" + "<tr><th>Payment Type</th><td>" + rst.getString(1) + "</td></tr>"
					+ "<tr><th>Payment Number</th><td>" + rst.getString(2) + "</td></tr>"
					+ "<tr><th>Expiry Date</th><td>" + rst.getDate(3) + "</td></tr>" + "</table>"
					+ "<br><button onclick=\"window.location.href=\'order.jsp\'\">Yes, pay with this information</button><br>");

			while (rst.next()) {
				out.print("<table>" + "<tr><th>Payment Type</th><td>" + rst.getString(1) + "</td></tr>"
						+ "<tr><th>Payment Number</th><td>" + rst.getString(2) + "</td></tr>"
						+ "<tr><th>Expiry Date</th><td>" + rst.getDate(3) + "</td></tr>" + "</table>"
						+ "<br><button onclick=\"window.location.href=\'order.jsp\'\">Yes, pay with this information</button>");
			}
		}

	} catch (Exception e) {
		out.print(e);
	}
%>
</html>