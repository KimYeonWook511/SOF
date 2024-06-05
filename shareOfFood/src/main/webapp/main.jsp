<%@ page import="java.util.ArrayList"%>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="restaurant.RestaurantDAO" %>
<%@ page import="restaurant.Restaurant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 메인 페이지</title>
<!-- 라이브러리 등록 - jQuery, Bootstrap : CDN 방식-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="/css/navbar.css">
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
	<%
		BoardDAO boardDAO = new BoardDAO();
		ArrayList<Board> hotBoardList = boardDAO.getHotBoardList();
		
		request.setAttribute("boardDAO", boardDAO);
		request.setAttribute("hotBoardList", hotBoardList);
	
		RestaurantDAO restDAO = new RestaurantDAO();
		ArrayList<Restaurant> newRestList = restDAO.getNewRest();
		ArrayList<Restaurant> hotRestList = restDAO.getHotRest();
		
		request.setAttribute("restDAO", restDAO);
		request.setAttribute("newRestList", newRestList);	
		request.setAttribute("hotRestList", hotRestList);
	%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
    <div class="container">
    	<div class="hotBoardArea">
			<c:if test="${hotBoardList.size() == 0 }">
				<div class="hotBoardHeader">소문난 숨은 맛집</div>
				<hr>
				<div class="hotBoardList">
					<div class="hotBoardHeader" style="width: 600px;">소문난 숨은 맛집이 존재하지 않습니다.	</div>
				</div>
			</c:if>
			<c:if test="${hotBoardList.size() != 0 }">
				<div class="hotBoardHeader">소문난 숨은 맛집</div>
				<hr>
				<div class="hotBoardList">
					<c:forEach var="board" items="${hotBoardList }" varStatus="status">
						<div class="hotBoard${status.index + 1 }">
							<div class="background">
								<a onclick="location.href = '/board/view.jsp?no=${board.getNo() }'" style="position: relative;">
									${thumbnail = -1;'' }
									<c:forEach var="boardimg" items="${boardDAO.getBoardImg(board.getNo()) }" varStatus="imgStatus">
										<c:if test="${boardimg != null && thumbnail == -1}">
											${thumbnail = imgStatus.index;'' }
										</c:if>
									</c:forEach>
									<c:if test="${thumbnail == -1 }">
										<img src="/css/img/NOIMAGE.png" style="width: 480px; height: 250px;">
									</c:if>
									<c:if test="${thumbnail != -1 }">
										<img src="/img/${boardDAO.getBoardImg(board.getNo()).get(thumbnail) }" style="width: 480px; height: 250px;">
									</c:if>
									<div class="hotBoardTitle">
										<span class="hotBoardTitle-inner">${board.getTitle() }</span>
									</div>
								</a>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>
		</div>
		<div class="newRestArea">
			<c:if test="${newRestList.size() == 0 }">
				<div class="newRestHeader">신규 맛집</div>
				<hr>
				<div class="newRestList">
					<div class="newRestHeader" style="width: 600px;">새로운 맛집이 존재하지 않습니다.</div>
				</div>
			</c:if>
			<c:if test="${newRestList.size() != 0 }">
				<div class="newRestHeader">신규 맛집</div>
				<hr>
				<div class="newRestList">
					<c:forEach var="rest" items="${newRestList }" varStatus="status">
						<div class="newRest${status.index + 1 }">
							<div class="background">
								<a onclick="location.href = '/restaurant/restaurant_view.jsp?no=${rest.getNo() }'" style="position: relative;">
									${thumbnail = -1;'' }
									<c:forEach var="restimg" items="${restDAO.getRestaurantImg(rest.getNo()) }" varStatus="imgStatus">
										<c:if test="${restimg != null && thumbnail == -1}">
											${thumbnail = imgStatus.index;'' }
										</c:if>
									</c:forEach>
									<c:if test="${thumbnail == -1 }">
										<img src="/css/img/NOIMAGE.png" style="width: 480px; height: 250px;">
									</c:if>
									<c:if test="${thumbnail != -1 }">
										<img src="/restaurantImg/${restDAO.getRestaurantImg(rest.getNo()).get(thumbnail) }" style="width: 480px; height: 250px;">
									</c:if>
									<div class="newRestTitle">
										<span class="newRestTitle-inner">${rest.getTitle() }</span>
									</div>
								</a>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>
		</div>
		<div class="hotRestArea">
			<c:if test="${hotRestList.size() == 0 }">
				<div class="hotRestHeader">인기 만점 맛집</div>
				<hr>
				<div class="hotRestList">
					<div class="hotRestHeader" style="width: 600px;">인기있는 맛집이 존재하지 않습니다.</div>
				</div>
			</c:if>
			<c:if test="${hotRestList.size() != 0 }">
				<div class="hotRestHeader">인기 만점 맛집</div>
				<hr>
				<div class="hotRestList">
					<c:forEach var="rest" items="${hotRestList }" varStatus="status">
						<div class="hotRest${status.index + 1 }">
							<div class="background">
								<a onclick="location.href = '/restaurant/restaurant_view.jsp?no=${rest.getNo() }'" style="position: relative;">
									${thumbnail = -1;'' }
									<c:forEach var="restimg" items="${restDAO.getRestaurantImg(rest.getNo()) }" varStatus="imgStatus">
										<c:if test="${restimg != null && thumbnail == -1}">
											${thumbnail = imgStatus.index;'' }
										</c:if>
									</c:forEach>
									<c:if test="${thumbnail == -1 }">
										<img src="/css/img/NOIMAGE.png" style="width: 480px; height: 250px;">
									</c:if>
									<c:if test="${thumbnail != -1 }">
										<img src="/restaurantImg/${restDAO.getRestaurantImg(rest.getNo()).get(thumbnail) }" style="width: 480px; height: 250px;">
									</c:if>
									<div class="hotRestTitle">
										<span class="hotRestTitle-inner">${rest.getTitle() }</span>
									</div>
								</a>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>
		</div>
    </div>
    <jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>