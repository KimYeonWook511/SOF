<%@ page import="java.util.ArrayList"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="restaurant.Restaurant"%>
<%@ page import="restaurant.RestaurantDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 검색 결과</title>
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
<link rel="stylesheet" href="/css/searchResult.css">
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
<%
	String search = null;
	
	if (request.getParameter("search") != null)
	{
		search = request.getParameter("search");
	}
	
	if (search.equals(""))
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('검색창에 입력을 해 주세요.')");
		script.println("history.back()");
		script.println("</script>");
	}

	RestaurantDAO restDAO = new RestaurantDAO();
	ArrayList<Restaurant> searchList = restDAO.searchRestaurant(search);
	
	request.setAttribute("restDAO", restDAO);
	request.setAttribute("searchList", searchList);	
%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<div class="main">
		<div class="column-main">
				<c:if test="${searchList.size() == 0 }">
					<div class="column-main-header">"<%=search %>"에 대한 검색 결과는 존재하지 않습니다.</div>	
				</c:if>
				<c:if test="${searchList.size() != 0 }">
					<div class="column-main-header">"<%=search %>"에 대한 검색 결과</div>
					<div class="column-main-inner">
						<c:forEach var="rest" items="${searchList }" varStatus="status">				
								<div class="background">
									<a onclick="location.href = '/restaurant/restaurant_view.jsp?no=${rest.getNo() }'" style="position: relative;">
										${thumbnail = -1;'' }
										<c:forEach var="restimg" items="${restDAO.getRestaurantImg(rest.getNo()) }" varStatus="imgStatus">
											<c:if test="${restimg != null && thumbnail == -1}">
												${thumbnail = imgStatus.index;'' }
											</c:if>
										</c:forEach>
										<c:if test="${thumbnail == -1 }">
											<img src="/css/img/NOIMAGE.png" style="width: 420px; height: 200px;">
										</c:if>
										<c:if test="${thumbnail != -1 }">
											<img src="/restaurantImg/${restDAO.getRestaurantImg(rest.getNo()).get(thumbnail) }" style="width: 420px; height: 200px;">
										</c:if>
										<div class="restTitle">
											<span class="restTitle-inner">${rest.getTitle() }</span>
										</div>
									</a>
								</div>
						</c:forEach>
					</div>
				</c:if>
		</div>
		<div class="column-side">
			<div id="map" style="width:400px; height:500px;"></div>
		</div>
	</div>
	<script>
		let addrList = [];

		<%
			for (int i = 0; i < searchList.size(); i++)
			{
	 	%>
				addrList.push("<%=searchList.get(i).getAddr() %>");
		<%
			}
 		%>
		for (let i = 0; i < addrList.length; i++)
		{
			console.log(addrList[i]);
		}
		
		$(document).ready(function(){
			searchMapMarker(addrList);
		});
	</script>
	<script src="/maps/rest_searchResult.js"></script>
</body>
</html>