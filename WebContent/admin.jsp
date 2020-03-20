<%@ include file="auth.jsp"%>
	<%@ page import="java.text.NumberFormat"%>
	<%@ include file="jdbc.jsp"%>
	<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<h1>Administrator Sales Report by Day</h1>
<body>

	<%
		getConnection();
		
		try (Statement stmt = con.createStatement();) {
			
			
			String sql = "SELECT CAST(orderDate AS DATE), SUM(totalAmount) FROM ordersummary GROUP BY CAST(orderDate AS DATE)";
			
			
			out.println("<table style='border-collapse:collapse;'><tr>"  //Add to cart column
					+ "<th>Order Date</th>" 
					+ "<th>Total Order Amount</th>"
					+ "</tr>");

			ResultSet rst=stmt.executeQuery(sql);
			
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			while(rst.next()){	
				
				out.println("<tr>"
						+ "<td valign='top'>"+ rst.getDate(1)+"</td>"
						+ "<td valign='top' style='text-align:right'>"+ currFormat.format(rst.getDouble(2))+"</td>" 
						+ "</tr>");
			}
			out.println("</table>");

			
			
		} catch (SQLException e) {
			out.print("<p>Error. "+e+"</p>");
		}
		closeConnection();

		
	
	%>

</body>
</html>
