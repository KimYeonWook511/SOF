<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 숨은 맛집 보기</title>
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
<link rel="stylesheet" href="/css/board.css">
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
			
		Board board = new BoardDAO().getBoard(no);
		ArrayList<String> boardImgList = new BoardDAO().getBoardImg(no);
		
		if (userID != null)
		{
			int result = new BoardDAO().upViewCount(board.getNo(), board.getViewCount());
			
			if (result == -1)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('조회수 오류')");
				script.println("</script>");
			}
			else
			{
				board.setViewCount(board.getViewCount() + 1);
			}
		}
		
		request.setAttribute("no", no);
		request.setAttribute("board", board);
		request.setAttribute("boardImgList", boardImgList);
	%>
	<c:if test="${no == 0 || board == null }">
		<script>
			alert('존재하지 않는 게시물입니다.');
			location.href = '/board/list.jsp';
		</script>
	</c:if>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<div class="board_imgMain">
		${notImg = true;'' }
		<c:forEach var="boardimg" items="${boardImgList }">
			<c:if test="${boardimg != null }">
				<span class="board_img"><img class="board_imgtag" src="/img/${boardimg }"></span>
				${notImg = false;'' }
			</c:if>
		</c:forEach>
		<c:if test="${notImg == true }">
			<div class="board_notimg"><div class="board_notimg_inner">등록된 사진이 없습니다.</div></div>
		</c:if>
	</div>
	<hr>
	<div class="main">
		<div class="column-main">
			<div class="board-title">
				<div class="board-name">${board.getTitle() }</div>
				<div class="board-status">
					<div class="status-viewCount">조회수 : ${board.getViewCount() }</div>
					<div class="status-write">
						<span class="status-writer">작성자 : ${board.getWriter() }</span>
						<span class="status-writeDate">작성일 : ${board.getWriteDate() }</span>
					</div>
					<hr class="hr-bar">
				</div>
			</div>
			<div class="board-info">
				<table class="info-table">
					<tr>
						<th class="board_info_th">주소</th>
						<td>${board.getAddr() }</td>
					</tr>
					<tr>
						<th class="board_info_th">분류</th>
						<td>${board.getType() }</td>
					</tr>
					<tr>
						<th class="board_info_th">가격</th>
						<td>${board.getPrice() }</td>
					</tr>
					<tr>
						<th class="board_info_th">소개내용</th>
						<td>${board.getRepContent() }</td>
					</tr>
				</table>
				<c:if test="${sessionScope.userID != null && sessionScope.userID.equals(board.getWriter()) || sessionScope.userID.equals('root') }">
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="/board/deleteAction.jsp?no=${no }" class="btn btn-default pull-right">삭제</a>
					<a href="/board/updateForm.jsp?no=${no }" class="btn btn-default pull-right">수정</a>	
				</c:if>
			</div>
		</div>
		<div class="column-side">
			<div id="map" style="width:400px;height:400px;"></div>
		</div>
	</div>
	<script>
		const addr = "<%=board.getAddr()%>";
		$(document).ready(function(){
			var h = 350;
			var w = ($(window).width())/5-4;
			$('.board_imgMain').css({height:h+'px', width:$(window).width()+'px'});
			$('.board_notimg').css({height:h+'px', width:$(window).width()+'px'});
			$('.board_img').css({height:h+'px', width:w+'px'});
			$('.board_imgtag').css({height:h+'px', width:w+'px'});
		});
	</script>
	<script src="/maps/rest_map_view.js"></script>
	<jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>