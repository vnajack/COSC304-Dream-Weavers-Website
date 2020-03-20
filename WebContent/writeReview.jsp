<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Write a Review</title>
	</head>
	<h1>Write a Review</h1>
	<h3>Please fill-in the following fields to rate 
	<%
	try	{
		String productId = request.getParameter("productId");
		getConnection();
		String sqlProdName = "SELECT productName FROM product WHERE productId = ?";
		PreparedStatement pstmt = con.prepareStatement(sqlProdName);
		pstmt.setInt(1, Integer.parseInt(productId));
		ResultSet rst = pstmt.executeQuery();
		while(rst.next()){
			out.print(rst.getString(1));
		}
		
		
	}catch(Exception e){
		out.print("this product");
	}
	%>
	</h3>

	<form name="writeReview" method=post action="validateReview.jsp" autocomplete="off">
		<table>
		<%
		//TODO: reviewId autoincrements. do we need to send it?
		%>
			<tr>
				<th><label for="reviewRating">Rating: </label></th>
				<td><input required type="number" name="reviewRating" size=40 placeholder="0-5" min="0" max= "5" title="Please rate your experience between 0 and 5 (5 being an excellent experience)"></td>
			</tr>
		<%
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormatter = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
		
		out.print("<tr>"
					+"<th><label for='reviewDate'>Date: </label></th>"
					+"<td><input disabled type='text' name='reviewDate' value="+ dateFormatter.format(date) +"></td>"
					+"</tr>");
		%>

			<tr>
				<th><label for="reviewComment">Comment: </label></th>
				<td><textarea name="reviewComment" form="writeReview" placeholder="Enter your comment here..." style="padding:'8px 12px';margin:'4px 0';border:'1px solid #ccc';border-radius:'4px'"></textarea></td>
			</tr>
		</table>
		<input class="submit" type="submit" name="SubmitReview" value="Submit">
	</form>
</html>