<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>


<!DOCTYPE html>
<html>
<head>
<title>Edit Product List</title>
</head>
<body>
	<h1>Edit Product List</h1>

	<p>Browse dreams by category or search by product name:</p>

	<form method="get" action="listprod.jsp" autocomplete="off"
		style="color: black">
		<p align="left">
			<select size="1" name="categoryName">
				<option value="">Choose a category...</option>
				<%
					try {
						getConnection();
						String sql = "SELECT categoryName FROM category; ";
						PreparedStatement pstmt = con.prepareStatement(sql);
						ResultSet rst = pstmt.executeQuery();
						while (rst.next()) {
							out.print("<option>" + rst.getString(1) + "</option>");
						}

					} catch (Exception e) {
						System.err.print(e);
					}
				%>
			</select> <input type="text" name="productName" size="50"
				placeholder="Product name... (leave blank for all products)">
			<input type="submit" value="Search"> <input type="reset"
				value="Reset">
	</form>

	<%
		// Get product name to search for
		String category = request.getParameter("categoryName");
		String name = request.getParameter("productName");

		//Variable 'name' now contains the search string the user entered
		//Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

		//Note: Forces loading of SQL Server driver

		// Make the connection
		getConnection();

		String sql = "SELECT productId, productName, productPrice, productImageURL, productDesc, categoryName "
				+ "FROM product " + "INNER JOIN category " + "ON product.categoryId = category.categoryId ";

		boolean productNameGiven = (name != null) && (!name.equals(""));
		boolean categoryNameGiven = (category != null) && (!category.equals(""));

		PreparedStatement pstmt = null;
		ResultSet rst = null;

		try {
			if (!productNameGiven && !categoryNameGiven) {
				pstmt = con.prepareStatement(sql);
				rst = pstmt.executeQuery();
			} else if (productNameGiven && !categoryNameGiven) {
				sql += " WHERE productName LIKE ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + name + "%");
				rst = pstmt.executeQuery();
				out.println("<p>Results for '" + name + "':</p>");
			} else if (!productNameGiven && categoryNameGiven) {
				sql += " WHERE categoryName LIKE ? ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + category + "%");
				rst = pstmt.executeQuery();
				out.println("<p>Results for '" + category + "':</p>");
			} else if (productNameGiven && categoryNameGiven) {
				sql += " WHERE productName LIKE ? AND categoryName LIKE ? ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + name + "%");
				pstmt.setString(2, "%" + category + "%");
				rst = pstmt.executeQuery();
				out.println("<p>Results for '" + name + "' in '" + category + "':</p>");
			}

			//Table showing ResultSet
			out.print("<table style='border-collapse: collapse'>");

			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			while (rst.next()) {
				int r = (int) (150 + Math.random() * (255 - 150));
				int g = (int) (150 + Math.random() * (255 - 150));
				int b = (int) (150 + Math.random() * (255 - 150));

				String deleteProductLink = "deleteproduct.jsp?productId=" + rst.getString("productId");

				String productDetailLink = "product.jsp?id=" + rst.getString("productId");
				String prod = rst.getString("productName");

				String prodImg = rst.getString("productImageURL");

				out.println("<tr>"

						+ "<td><div class='container'><a href='" + productDetailLink + "'><img src='" + prodImg
						+ "'></a></div></td>" + "<td><a href='" + productDetailLink
						+ "' style='font-size:20px;color:rgb(" + r + "," + g + "," + b + ")'><b>"
						+ rst.getString("productName") + "</b></a>" + "<br><span style='font-size:14px'>Category: "
						+ rst.getString("categoryName")
						+ "<br>Rating: " /*AVERAGE REVIEW RATING + rst.getInt("reviewRating") */ + "/5" + "<br>CAD"
						+ currFormat.format(rst.getDouble("productPrice")) + "<br><a href='" + deleteProductLink
						+ "'><button>Delete Product</button></a>" + "</td>" + "</tr>");
			}
			out.println("</table>");
		} catch (SQLException e) {
			out.print("<p>Error. " + e + "</p>");
		}
	%>

</body>
</html>