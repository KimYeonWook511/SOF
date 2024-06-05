<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 상단 navbar</title>
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
<%
	String userID = (String)session.getAttribute("userID");
%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/main.jsp">SOF</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="/main.jsp">메인</a></li>
				<li><a href="/board/list.jsp">숨은 맛집</a></li>
				<%
					if (userID != null && userID.equals("root"))
					{
				%>
						<li><a href="/restaurant/info_inputForm.jsp">맛집 등록</a></li>
				<%
					}
				%>
				<li>
					<div class="search_btn">
						<input type="text" class="search_input" placeholder="지역, 음식점, 음식종류" maxlength="20">
					</div>	
				</li>
			</ul>
			<%
				if (userID == null)
				{
			%>
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdwon">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" 
								aria-expanded="false" style="font-weight: bold; font-size: 15px; padding-left: 20px; padding-right: 20px;">
								접속하기
							</a>
							<ul class="dropdown-menu">
								<!-- active는 선택된 메뉴 -->
								<li class="active"><a href="/user/loginForm.jsp">로그인</a></li> 
								<li><a href="/user/joinForm.jsp">회원가입</a></li>
							</ul>
						</li>
					</ul>
			<%
				}
				else
				{
			%>
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdwon">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" 
								aria-expanded="false" style="font-weight: bold; font-size: 15px; padding-left: 20px; padding-right: 20px;">
								<%=userID %>
							</a>
							<ul class="dropdown-menu">
								<li><a href="/user/logoutAction.jsp">로그아웃</a></li> 							
							</ul>
						</li>
					</ul>
			<%
				}
			%>
		</div>
	</nav>
    <script>
        $(document).ready(function() {
            $(".search_input").keydown(function(key) {
                if (key.keyCode == 13) {
                    location.href = '/search/searchResult.jsp?search=' + document.querySelector('.search_input').value;
                }
            });
        });
    </script>
</body>
</html>