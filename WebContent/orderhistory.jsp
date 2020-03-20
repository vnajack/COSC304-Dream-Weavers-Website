<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Order History</title>
</head>
<body>
	<h1>Your Order History</h1>

	<%
		String userid = (String) session.getAttribute("authenticatedUser");
		if (userid == null) {
			out.print("<p style='color:red'>You are not logged in. Please log in to see your order history</p>"
					+ "<button onclick=\"window.location.href=\'login.jsp\'\">Login</button>"
					+ "<p>Don\'t have an account?</p><button onclick=\"window.location.href=\'createCustomer.jsp\'\">Create an Account</button>");
		} else {
			try { // Load driver class
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			} catch (java.lang.ClassNotFoundException e) {
				out.println("ClassNotFoundException: " + e);
			}
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
			String uid = "vjack";
			String pw = "12304986";
			try (Connection con = DriverManager.getConnection(url, uid, pw);) {
				String query1 = "SELECT ordersummary.orderId, ordersummary.orderDate, ordersummary.customerId, customer.firstName, customer.lastName, ordersummary.totalAmount "
						+ "FROM ordersummary, customer "
						+ "WHERE ordersummary.customerId = customer.customerId AND customer.userId = ?";
				String query2 = "SELECT orderId, productId, quantity, price FROM orderproduct WHERE orderId = ?";
				String queryProdName = "SELECT productName from product WHERE productId = ?";
				String query3 = "SELECT reviewDate, reviewRating FROM review r inner join customer c ON r.customerId = c.customerId WHERE c.userId= ? AND productId = ?";
				PreparedStatement pstmt = con.prepareStatement(query1);
				pstmt.setString(1, userid);
				PreparedStatement pstmt2 = con.prepareStatement(query2);
				pstmt2.setString(1, userid);
				PreparedStatement pstmt3 = con.prepareStatement(query3);//Jeff
				ResultSet rst = pstmt.executeQuery();
				ResultSet rst2 = pstmt2.executeQuery();
				//Outer Table
				out.print("<table style='border-collapse:collapse; float:center'>" + "<tr>" //outer header row (1st row)
						+ "<th>Order Id</th>" + "<th>Order Date</th>" + "<th>Customer Id</th>"
						+ "<th>Customer Name</th>" + "<th>Order Summary <br>"
						+ "<table style='width:auto;float:center'>" + "<tr>" //inner table header row
						+ "<th width='100px'>Product Name</th>" + "<th width='100px'>Quantity</th>"
						+ "<th width='100px'>Price</th>" + "<th width='150px'>Write a Review</th></tr></table>" //end of inner table header row
						+ "</th>" + "<th>Total</th>" + "</tr>"); //end of header row (1st row)
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();
				while (rst.next()) {
					out.print("<tr style='border-bottom: 1px solid #243743;'>" //outer table content begins (2nd row)
							+ "<td align='center'>" + rst.getInt(1) + "</td>" //Order Id
							+ "<td align='center'>" + rst.getDate(2) + " " + rst.getTime(2) + "</td>" //Order Date
							+ "<td align='center'>" + rst.getInt(3) + "</td>" //Customer Id
							+ "<td align='left'>" + rst.getString(4) + " " + rst.getString(5) + "</td>" //Customer Name
							+ "<td align='center'>");
					pstmt2.setInt(1, rst.getInt(1));
					rst2 = pstmt2.executeQuery();
					//Inner Table header
					out.print("<table style='float:center'>"); //inner table
					while (rst2.next()) {
						int productId = rst2.getInt(2);//Jeff
						PreparedStatement pstmtPN = con.prepareStatement(queryProdName);
						pstmtPN.setInt(1, productId);
						ResultSet rstPN = pstmtPN.executeQuery();
						String prodName = "";
						while (rstPN.next()) {
							prodName = rstPN.getString(1);
						}
						out.println("<tr>" + "<td align='center' width='100px'>" + prodName + "</td>" //product name
								+ "<td align='center' width='100px'>" + rst2.getInt(3) + "</td>" //quantity
								+ "<td align='center' width='100px'>" + currFormat.format(rst2.getDouble(4))
								+ "</td>"); //price
						pstmt3.setString(1, userid);//Jeff
						pstmt3.setInt(2, productId);//Jeff
						ResultSet rst3 = pstmt3.executeQuery();//Jeff

						String writeReviewLink = "writeReview.jsp?productId=" + productId;//Tatiana

						if (!rst3.next()) { //Jeff
							out.print("<td align='center' width='150px'><a href='" + writeReviewLink
									+ "'><button>Review this product</button></a></td>");//needs a jsp for writing the review//Jeff
						} else {
							out.print("<td align='center' width='150px'>You rated this product as "
									+ rst3.getInt("reviewRating") + " out of 5.</td>");
						}
						out.print("</tr>");
					} //End of Inner Table
					out.println("</table>"); //End of inner table
					out.print("<td align='right'>" + currFormat.format(rst.getDouble(6)) + "</td></tr>"); //Total Amount
					out.println("</tr>");
				} //while(rst.next())
				out.println("</table>");
			} catch (SQLException e) {
				out.print("<p>Error. " + e + "</p>");
			}
		}
	%>

</body>
</html>