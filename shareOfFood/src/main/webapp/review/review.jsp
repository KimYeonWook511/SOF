<%@ page import="restaurant.RestaurantDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="review.ReviewDAO" %>
<%@ page import="review.Review"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 리뷰 보기</title>
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
		String userID = (String)session.getAttribute("userID");
		
		if (request.getParameter("no") != null)
		{
			no = Integer.parseInt(request.getParameter("no"));
		}
			
		Review review = new ReviewDAO().getReview(no);
		ArrayList<String> reviewImgList = new ReviewDAO().getReviewImg(no);
		String restTitle = new RestaurantDAO().getRestaurant(review.getRestNo()).getTitle();
		
		request.setAttribute("no", no);
		request.setAttribute("review", review);
		request.setAttribute("reviewImgList", reviewImgList);
		request.setAttribute("restTitle", restTitle);
	%>
	<c:if test="${no == 0 || review == null }">
		<script>
			alert('존재하지 않는 리뷰입니다.');
			location.href = '/index.jsp';
		</script>
	</c:if>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<div class="container">
		<h1>"${restTitle }" 맛집 리뷰</h1>
		<table class="table">
			<tr>
				<td style="width: 20%;">제목</td>
				<td colspan="2">${review.getTitle() }</td>
			</tr>
			<tr>
				<td>작성자</td>
				<td colspan="2">${review.getWriter() }</td>
			</tr>
			<tr>
				<td>작성일</td>
				<td colspan="2">${review.getWriteDate() }</td>
			</tr>
			<tr>
				<td>내용</td>
				<td style="word-wrap: break-word; word-break: break-all;">${review.getRepContent() }</td>
			</tr>
			<tr>
				<td colspan="3"></td>
			</tr>
		</table>
		${flag = false;'' }
		<c:forEach var="reviewImg" items="${reviewImgList }">
			<c:if test="${reviewImg != null }">
				${flag = true;'' }
			</c:if>
		</c:forEach>
		<c:if test="${flag == true }"> <!-- 등록된 사진이 있을 경우에 myCarousel 생성 -->
			${firstImg = true;'' }
			<div class="container">
				<div id="myCarousel" class="carousel slide" data-ride="carousel" style="width: 400px; height: 300px;">
					<ol class="carousel-indicators">
						<c:forEach var="reviewImg" items="${reviewImgList }" varStatus="status">
							<c:choose>
								<c:when test="${reviewImg != null && firstImg == true }">
									<li data-target="#myCarousel" data-slide-to="${status.count }" class="active">
									${firstImg = false;'' }
								</c:when>
								<c:when test="${reviewImg != null }">
									<li data-target="#myCarousel" data-slide-to="${status.count }">
								</c:when>
							</c:choose>
						</c:forEach>
					</ol>
					${firstImg = true;'' }
					<div class="carousel-inner">
						<c:forEach var="reviewImg" items="${reviewImgList }" varStatus="status">
							<c:choose>
								<c:when test="${reviewImg != null && firstImg == true }">
									<div class="item active">
										<img src="/reviewImg/${reviewImg }" style="width: 400px; height: 300px;">
										${firstImg = false;'' }
									</div>
								</c:when>
								<c:when test="${reviewImg != null }">
									<div class="item">
										<img src="/reviewImg/${reviewImg }" style="width: 400px; height: 300px;">
									</div>
								</c:when>
							</c:choose>
						</c:forEach>
					</div>
					<a class="left carousel-control" href="#myCarousel" data-slide="prev">
					<span class="glyphicon glyphicon-chevron-left"></span>
				</a>
				<a class="right carousel-control" href="#myCarousel" data-slide="next">
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
			</div>
		</div>
		<br>
		</c:if>
		<c:if test="${sessionScope.userID != null && sessionScope.userID.equals(review.getWriter()) }">
			<a href="/review/review_updateForm.jsp?no=${no }" class="btn btn-default">수정</a>
			<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="/review/review_deleteAction.jsp?no=${no }" class="btn btn-default">삭제</a>
		</c:if>
		<a href="/restaurant/restaurant_view.jsp?no=${review.getRestNo() }" class="btn btn-default">뒤로가기</a>
	</div>
	<jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>