<%@ page import="restaurant.RestaurantDAO"%>
<%@ page import="restaurant.Restaurant"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="review.ReviewDAO"%>
<%@ page import="review.Review"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 리뷰 수정 하기</title>
<!-- 라이브러리 등록 - jQuery, Bootstrap : CDN 방식-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
	<%
		int no = 0;
	
		if (session.getAttribute("userID") == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해 주세요.')");
			script.println("location.href = '/user/loginForm.jsp'"); // 로그인 페이지로 이동
			script.println("</script>");
		}
		else
		{
			if (request.getParameter("no") != null)
			{
				no = Integer.parseInt(request.getParameter("no"));
			}
			
			Review review = new ReviewDAO().getReview(no);
			
			if (no == 0 || review == null)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('존재하지 않는 리뷰입니다.')");
				script.println("location.href = '/index.jsp'");
				script.println("</script>");
			}
			
			if (!session.getAttribute("userID").equals(review.getWriter()))
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유저의 정보가 일치하지 않습니다.')");
				script.println("location.href = '/index.jsp'");
				script.println("</script>");
			}
			
			ArrayList<String> reviewImgList = new ReviewDAO().getReviewImg(no);
	%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<div class="container">
		<h1>"<%=new RestaurantDAO().getRestaurant(review.getRestNo()).getTitle() %>"리뷰 수정하기</h1>
		<form action="/review/review_updateAction.jsp?no=<%= no %>" method="post" enctype="multipart/form-data">
			<div class="form-group">
				<label>제목 : </label>
				<input type="text" class="form-control" name="title" placeholder="제목을 5자 이상 입력해 주세요." maxlength="50" value="<%= review.getTitle() %>">
			</div>
			<div class="form-group">
				<label>내용 :</label>
				<textarea class="form-control" rows="5" name="content" maxlength="5000" ><%= review.getContent() %></textarea>
			</div>
			<div class="form-group">
				<label>이미지 : </label>
				<table class="review_imgFile">
					<tr>
						<td><input type="file" name="img1" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
						<td><input type="file" name="img2" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
						<td><input type="file" name="img3" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
						<td><input type="file" name="img4" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
						<td><input type="file" name="img5" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
					</tr>
				</table>
				<div class="review_imgMain">
			    <%
			    	for (int i = 0; i < reviewImgList.size(); i++)
			    	{
			    		if (reviewImgList.get(i) == null)
			    		{
			    %>
			        		<span class="review_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
			    <%    
			    		}
			    		else
			    		{
			    %>
			        		<span class="review_img" style="display: table-cell; text-align: center; vertical-align: middle;"><img class="review_imgtag" src="/reviewImg/<%=reviewImgList.get(i) %>"></span>
			    <%
			    		}
			    	}
			    %>
				</div>
			</div>
			<div class="form-group">
				<label>작성자 : <%= review.getWriter() %></label> 
			</div>
			<input type="submit" class="btn btn-default" value="리뷰 수정">
			<button onclick="history.back()"class="btn btn-default">뒤로가기</button>	
		</form>
	</div>
<%
	}
%>
<script>
	let input = document.querySelectorAll('[type="file"]');
	let preview = document.querySelectorAll('.review_img');
	for(let i=0; i<input.length; i++) {
	    input[i].addEventListener('change', function(e) {
	        let file = e.target.files;
	        if(file.length) {
	            let reader = new FileReader();
	            reader.readAsDataURL(file[0]);
	            reader.onload = function() {
	                let dataUrl = reader.result;
	                preview[i].innerHTML = '<img src="' + dataUrl + '" style="height:'+ $('.review_img').height() +'px; width:'+ $('.review_img').width() +'px;">';
	            }
	        } else {
	            preview[i].innerHTML = '미리보기';
	        }
	    })
	}
</script>
<script>
	$(document).ready(function(){
		var h = 220;
		var w = ($('.container').width())/5;
		$('.review_imgFile').css({width:$('.container').width()+'px'});
		$('.file_input').css({width:w+'px'});
		$('.review_imgMain').css({height:h+'px', width:$('.container').width()+'px'});
		$('.review_img').css({height:h+'px', width:w+'px'});
		$('.review_imgtag').css({height:h+'px', width:w+'px'});
	});
</script>
<jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>