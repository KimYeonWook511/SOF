<%@ page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 등록 하기</title>
<!-- 라이브러리 등록 - jQuery, Bootstrap : CDN 방식-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- 카카오 지도 api -->
<script 
    type="text/javascript" 
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=28e05f70686110a899f17cd6caf1e542&libraries=services"></script>
<!-- 음식점 정보 css -->
<link rel="stylesheet" href="/css/restaurant_view.css">
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
	<%
		String userID = (String)session.getAttribute("userID");
	
		if (userID == null || !userID.equals("root"))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('해당 권한이 없습니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		else
		{
	%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<form action="info_inputAction.jsp" method="post" enctype="multipart/form-data">
		<table class="rest_imgFile">
			<tr>
				<td><input type="file" name="img1" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
				<td><input type="file" name="img2" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
				<td><input type="file" name="img3" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
				<td><input type="file" name="img4" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
				<td><input type="file" name="img5" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
			</tr>
		</table>
		<div class="rest_imgMain">
			<span class="rest_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
			<span class="rest_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
			<span class="rest_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
			<span class="rest_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
			<span class="rest_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
		</div>
		<hr>
		<div class="main">
			<div class="column-main">
				<div class="restaurant-title">
					<div class="restaurant-name" style="font-size: 20px;">
						맛집 이름<br>
						<input type="text" name="title" maxlength="50" placeholder="ex)수라국수(인하대점)" style="width: 800px; height: 30px;">
					</div>
					<div class="restaurant-status">
						<span style="margin-right: 10px;">조회수 : OOO</span>
						<span style="margin-right: 10px;">리뷰수 : OOO</span>
						<span style="margin-right: 10px;">좋아요 : OOO</span>
						<hr>
					</div>
				</div>
				<div class="restaurant-info">
					<table class="info-table">
						<tr>
							<th class="rest_info_th">주소</th>
							<td>
								<input type="text" name="addr" id="searchMap" placeholder="ex)인천광역시 미추홀구 용현동 191-93" maxlength="50" style="width: 500px; height: 30px;">
								<button id="searchBtn" class="btn btn-default" type="button">검색</button>
							</td>
						</tr>
						<tr>
							<th class="rest_info_th">전화번호</th>
							<td><input type="text" name="phoneNumber" placeholder="ex)032-000-0000" maxlength="50" style="width: 500px; height: 30px;"></td>
						</tr>
						<tr>
							<th class="rest_info_th">분류</th>
							<td><input type="text" name="type" placeholder="ex)면, 국수" maxlength="50" style="width: 500px; height: 30px;"></td>
						</tr>
						<tr>
							<th class="rest_info_th">가격</th>
							<td><input type="text" name="price" placeholder="ex)4000원 ~ 8000원" maxlength="50" style="width: 500px; height: 30px;"></td>
						</tr>
						<tr>
							<th class="rest_info_th">영업시간</th>
							<td><input type="text" name="businessTime" placeholder="ex)평일 09:00 ~ 22:00 토,일 09:00 ~ 20:00" maxlength="50" style="width: 500px; height: 30px;"></td>
						</tr>
						<tr>
							<th class="rest_info_th">쉬는시간</th>
							<td><input type="text" name="breakTime" placeholder="ex)매일 14:00 ~ 15:00" maxlength="50" style="width: 500px; height: 30px;"></td>
						</tr>
						<tr>
							<td colspan="2"><button class="btn btn-default pull-right">맛집 등록</button></td>
						</tr>
					</table>
				</div>	
				<div class="restaurant-review">
					<!-- 리뷰 영역 -->
				</div>
			</div>
			<div class="column-side">
				<div id="map" style="width:400px;height:400px;"></div>
			</div>
		</div>
	</form>
	<script src="/maps/searchMap.js"></script>
	<script>
		let input = document.querySelectorAll('[type="file"]');
		let preview = document.querySelectorAll('.rest_img');
		for(let i=0; i<input.length; i++) {
		    input[i].addEventListener('change', function(e) {
		        let file = e.target.files;
		        if(file.length) {
		            let reader = new FileReader();
		            reader.readAsDataURL(file[0]);
		            reader.onload = function() {
		                let dataUrl = reader.result;
		                preview[i].innerHTML = '<img src="' + dataUrl + '" style="height:'+ $('.rest_img').height() +'px; width:'+ $('.rest_img').width() +'px;">';
		            }
		        } else {
		            preview[i].innerHTML = '미리보기';
		        }
		    })
		}
	</script>
	<script>
		$(document).ready(function(){
			var h = 350;
			var w = ($(window).width())/5-5;
			$('.rest_imgFile').css({width:$(window).width()+'px'});
			$('.file_input').css({width:w+'px'});
			$('.rest_imgMain').css({height:h+'px', width:$(window).width()+'px'});
			$('.rest_img').css({height:h+'px', width:w+'px'});
		});
	</script>
	<%
		}
	%>
	<jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>