<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp"%>

<!DOCTYPE html>
<html>
	<head>
		<title>Add Product</title>
	</head>
	<h1>Add a new product</h1>
	
	<br>
	<h3>Please fill-in the following fields to add a new product to Dream Vine:</h3>

	<form name="MyForm2" method=post action="validateNewProduct.jsp" autocomplete="off">
		<table>
			<tr>
				<th><label for="productName">Product Name: </label></th>
				<td><input type="text" name="productName" size=40 placeholder="Product Name" required></td>
			</tr>
			<tr>
				<th><label for="productPrice">Product Price (CAD): </label></th>
				<td><input type="text" name="productPrice" size=10 placeholder="0.00" pattern="[0-9]{1,3}.[0-9]{2}" title="Must be between 0.00 and 999.99" required></td>
			</tr>
			<tr>
				<th><label for="productDesc">Product Description: </label></th>
				<td><input type="text" name="productDesc" size=70 placeholder="Description" required></td>
			</tr>
			<tr>
				<th><label for="categoryName">Category: </label></th>
				<td><select size="1" name="categoryName">
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
				</select></td>
			</tr>
		</table>
		
		<input class="submit" type="submit" name="Submit3" value="Add Product">
		
	</form>
</html>