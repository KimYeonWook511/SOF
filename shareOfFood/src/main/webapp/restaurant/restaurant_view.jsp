<%@ page import="review.Review"%>
<%@ page import="review.ReviewDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="restaurant.Restaurant" %>
<%@ page import="restaurant.RestaurantDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 보기</title>
<!-- 라이브러리 등록 - jQuery, Bootstrap : CDN 방식-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- 카카오 지도 api -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=28e05f70686110a899f17cd6caf1e542&libraries=services"></script>
<!-- 음식점 보기 css -->
<link rel="stylesheet" href="/css/restaurant_view.css">
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
	<%
		int no = 0;
		String userID = (String)session.getAttribute("userID");
		boolean isLike = false;
		
		if (request.getParameter("no") != null)
		{
			no = Integer.parseInt(request.getParameter("no"));
		}
			
		Restaurant rest = new RestaurantDAO().getRestaurant(no);
			
		if (no == 0 || rest == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('등록되지 않은 음식점입니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		
		if (userID != null)
		{
			int result = new RestaurantDAO().upViewCount(rest.getNo(), rest.getViewCount());
			
			if (result == -1)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('조회수 오류')");
				script.println("</script>");
			}
			else
			{
				rest.setViewCount(rest.getViewCount() + 1);
				result = new RestaurantDAO().isLike(no, userID);
				
				if (result == 1)
				{
					isLike = true;
				}
				else if (result == 0)
				{
					isLike = false;
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('해당 유저 좋아요 판별 오류')");
					script.println("</script>");
				}
			}
		}
		
		ArrayList<String> restImgList = new RestaurantDAO().getRestaurantImg(no); // 음식점 이미지 가져오기
		
		int like = new RestaurantDAO().getLikeCount(no); // 좋아요 수 가져오기
		
		ReviewDAO reviewDAO = new ReviewDAO();
		ArrayList<Review> reviewList = reviewDAO.getReviewList(no); // 리뷰 리스트 가져오기
		request.setAttribute("reviewDAO", reviewDAO);
		request.setAttribute("reviewList", reviewList);
	%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<div class="rest_imgMain">
	<%
		boolean notImg = true;
		
		for (int i = 0; i < restImgList.size(); i++)
		{
			if (restImgList.get(i) != null)
			{
	%>
				<span class="rest_img"><img class="rest_imgtag" src="/restaurantImg/<%=restImgList.get(i) %>"></span>
	<%
	 			notImg = false; // 음식점 이미지가 존재함
			}	
		}
	
		if (notImg)
		{
	%>
			<div class="rest_notimg"><div class="rest_notimg_inner">등록된 사진이 없습니다.</div></div>
	<%
		}
	 %>
	</div>
	<hr>
	<div class="main">
		<div class="column-main">
			<div class="restaurant-title">
				<div class="restaurant-name"><%=rest.getTitle() %></div>
				<div class="restaurant-status">
					<span class="status-inner">조회수 : <%=rest.getViewCount() %></span>
					<span class="status-inner">리뷰수 : ${reviewList.size() }</span>
					<span style="margin-left: 2px; margin-right: 10px;"><button type="button" class="rest_likeBtn btn" onclick="location.href = '/restaurant/restaurant_likeAction.jsp?no=<%=no%>'">좋아요 : <%=like %></button></span>
					<hr>
				</div>
			</div>
			<div class="restaurant-info">
				<table class="info-table">
					<tr>
						<th class="rest_info_th">주소</th>
						<td><%=rest.getAddr() %></td>
					</tr>
					<tr>
						<th class="rest_info_th">전화번호</th>
						<td><%=rest.getPhoneNumber() %></td>
					</tr>
					<tr>
						<th class="rest_info_th">분류</th>
						<td><%=rest.getType() %></td>
					</tr>
					<tr>
						<th class="rest_info_th">가격</th>
						<td><%=rest.getPrice() %></td>
					</tr>
					<tr>
						<th class="rest_info_th">영업시간</th>
						<td><%=rest.getBusinessTime() %></td>
					</tr>
					<tr>
						<th class="rest_info_th">쉬는시간</th>
						<td><%=rest.getBreakTime() %></td>
					</tr>
					<tr>
						<th class="rest_info_th">최근 업데이트</th>
						<td><%=rest.getUpdateTime() %></td>
					</tr>
				</table>
				<%
					if (userID != null && userID.equals("root"))
					{
				%>		
						<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="/restaurant/info_deleteAction.jsp?no=<%=no %>" class="btn btn-default pull-right">삭제</a>
						<a href="/restaurant/info_updateForm.jsp?no=<%=no %>" class="btn btn-default pull-right">수정</a>	
				<%
					}
				%>
			</div>
			<div class="restaurant-review">
				<div class="review-header">
					<hr>
					"<%=rest.getTitle() %>" 맛집 리뷰 (${reviewList.size() })
					<button type="button" class="btn btn-default pull-right" onclick="location.href = '/review/reviewForm.jsp?no=<%=no%>'">리뷰 작성하기</button>
				</div>
				<c:if test="${reviewList.size() == 0 }">
					<div class="review-main">
					<hr style="margin-top: 0px; margin-bottom: 15px; width: 800px">
						<div style="font-size:30px; font-weight: bold; color: rgba(79,79,79,0.6);">리뷰가 존재하지 않습니다.</div>
					</div>
				</c:if>
				<c:if test="${reviewList.size() != 0 }">
					<div class="review-main">
						<table class="table" style="margin-bottom: 0px;">
							<tr>
								<th style="width: 150px; text-align: center;">작성자</th>
								<th style="text-align: left;">내용</th>
								<th style="width: 100px; text-align: center;">작성일</th>
							</tr>
						</table>
						<hr style="margin-top: 0px; margin-bottom: 0px; width: 800px">
					</div>
					<c:forEach var="review" items="${reviewList }">
						<div class="review-data">
							<input type="hidden" class="no" value="${review.getNo()}">
							<div class="review-writer">
								<div class="review-writer-inner">
								${review.getWriter() }
								</div>
							</div>
							<div class="review-info">
								<div class="review-t-d">
									<div class="review-title">
										${review.getTitle() }
									</div>
									<div class="review-date">
										${review.getWriteDate() }
									</div>
								</div>
								<div class="review-content">
									${review.getRepContent() }
									${flag = false;'' }
									<c:forEach var="reviewImg" items="${reviewDAO.getReviewImg(review.getNo()) }">
										<c:if test="${reviewImg != null }">
											${flag = true;'' }
										</c:if>
									</c:forEach>
									<c:if test="${flag == true }"> <!-- 리뷰 사진이 있을 경우 영역 생성 -->
										<div class="review-imgMain">
											<c:forEach var="reviewImg" items="${reviewDAO.getReviewImg(review.getNo()) }" varStatus="status">
												<c:if test="${reviewImg == null }">
												</c:if>
												<c:if test="${reviewImg != null }">
													<span class="review-img">
														<img class="review-imgtag" src="/reviewImg/${reviewImg }" style="padding: 10px 15px 0 0;">
													</span>											
												</c:if>
											</c:forEach>							
										</div>						
									</c:if>								
								</div>
							</div>
						</div>
						<hr style="margin-top: 0px; margin-bottom: 0px; width: 800px">			
					</c:forEach>	
				</c:if>
			</div>
		</div>
		<div class="column-side">
			<div id="map" style="width:400px;height:400px;"></div>
		</div>
	</div>
	<script>
		const addr = "<%=rest.getAddr()%>";
		$(document).ready(function(){
			var h = 350;
			var w = ($(window).width())/5-5;
			var imgh = 100;
			var imgw = 100;
			$('.rest_imgMain').css({height:h+'px', width:$(window).width()+'px'});
			$('.rest_notimg').css({height:h+'px', width:$(window).width()+'px'});
			$('.rest_img').css({height:h+'px', width:w+'px'});
			$('.rest_imgtag').css({height:h+'px', width:w+'px'});
			$('.review-imgtag').css({height:imgh+'px', width:imgw+'px'});
			if (<%=isLike%> == true)
			{
				$('.rest_likeBtn').css({"color":"#333", "background-color":"#5bc0de", "border-color":"#46b8da"});
			}
			else
			{
				$('.rest_likeBtn').css({"color":"#BDBDBD", "background-color":"#fff", "border-color":"#ccc"});
			}
		});
	</script>
	<script>
		$(function() { // onready - html의 body 부분의 내용이 다 로딩되면 동작되도록 한다.
			// 데이터 한줄 클릭하면 글보기로 이동되는 이벤트 처리
			$(".review-data").click(function() { // dataRow 클래스가 클릭되면 function 실행
				location = '/review/review.jsp?no=' + $(this).find(".no").val();
			})
		});
	</script>
	<script src="/maps/rest_map_view.js"></script>
	<jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>