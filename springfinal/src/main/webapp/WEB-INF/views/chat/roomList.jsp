<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/leftSidebar.jsp"></jsp:include>


<style>

    .club-image {
        width: 80px; /* 원하는 크기로 조절하세요 */
        height: 80px; /* 원하는 크기로 조절하세요 */
        border-radius: 50%; /* 50%로 설정하여 동그란 형태로 만듭니다 */
        background-color: #D9D9D9;
    }
    .clubname-text{
    font-size: 20px;
    }
	.explain-text{
	color: A69D9D
	}
	.club-box:hover {
        background-color: #f0f0f0; /* 호버 효과 배경색 설정 */
        cursor: pointer; /* 호버 시 커서 모양 변경 */
    }

    .main-text{
    font-size: 20px;
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 동호회 설명 길이 제한 함수
        function truncateClubDescription() {
            const clubDescriptions = document.querySelectorAll('.explain-text');

            clubDescriptions.forEach(function (description) {
                const maxLength = 30; // 최대 길이 설정
                const text = description.textContent;

                if (text.length > maxLength) {
                    description.textContent = text.substring(0, maxLength) + '...';
                }
            });
        }

        // 페이지 로드 시 동호회 설명 길이 제한 실행
        truncateClubDescription();
    });
</script>

<body>

	<div class="row">
            <div class="col text-start d-flex align-items-center ms-3 mt-3">
                <img src="${pageContext.request.contextPath}/images/logo-door.png" width="5%">
                <strong class="ms-2 main-text">모임채팅</strong>
            </div>
        </div>
        
    <c:forEach var="roomList" items="${roomList}">
       <div class="row mt-3 ms-2 d-flex align-items-center club-box" onclick="enterRoom(${roomList.chatRoomNo})">
    <div class="col-2">
	<c:choose>
                 <c:when test="${roomList.attachNo > 0}">
                    <img src="${pageContext.request.contextPath}/club/image?clubNo=${roomList.clubNo}" class="rounded-circle" width="80" height="80">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/basic-profile.png" class="rounded-circle" width="80" height="80">
                </c:otherwise>
            </c:choose>
    </div>
    <div class="col">
        <div class="col">
            <span class="clubname-text">${roomList.clubName}</span> 
        </div>
        <div class="col">
            <span class="explain-text">${roomList.clubExplain}</span> 
        </div>
    </div>
</div>
    </c:forEach>
    
<hr>
<div class="row">
            <div class="col text-start d-flex align-items-center ms-3 mt-3">
                <img src="${pageContext.request.contextPath}/images/logo-door.png" width="5%">
                <strong class="ms-2 main-text">개인채팅</strong>
            </div>
        </div>

 <c:forEach var="oneChatRoom" items="${oneChatRoomList}">
    <div class="row mt-3 ms-2 d-flex align-items-center club-box" onclick="enterRoom(${oneChatRoom.chatRoomNo})" onmouseover="hoverEffect(this)" onmouseout="removeHoverEffect(this)">
        <div class="col-2">
        <c:choose>
    <c:when test="${sessionScope.name eq oneChatRoom.chatSender}">
        <c:choose>
            <c:when test="${oneChatRoom.receiverAttachNo eq 0}">
                <img src="${pageContext.request.contextPath}/images/basic-profile.png" class="rounded-circle" width="80" height="80">
            </c:when>
            <c:otherwise>
                <img src="/rest/member/profileShow?memberId=${oneChatRoom.chatReceiver}" class="rounded-circle" width="80" height="80">
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${oneChatRoom.senderAttachNo eq 0}">
                <img src="${pageContext.request.contextPath}/images/basic-profile.png" class="rounded-circle" width="80" height="80">
            </c:when>
            <c:otherwise>
                <img src="/rest/member/profileShow?memberId=${oneChatRoom.chatSender}" class="rounded-circle" width="80" height="80">
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>

        </div>
        <div class="col">
            <div class="col">
                <span class="clubname-text">
                    <c:choose>
                        <c:when test="${sessionScope.name eq oneChatRoom.chatSender}">
                            ${oneChatRoom.chatReceiver}님과의 채팅방
                        </c:when>
                        <c:otherwise>
                            ${oneChatRoom.chatSender}님과의 채팅방
                        </c:otherwise>
                    </c:choose>
                </span> 
            </div>
        </div>
    </div>
    <br/>
</c:forEach>

<hr>
<div class="row">
            <div class="col text-start d-flex align-items-center ms-3 mt-3">
                <img src="${pageContext.request.contextPath}/images/logo-door.png" width="5%">
                <strong class="ms-2 main-text">정모채팅</strong>
            </div>
        </div>
        
        <c:forEach var="meetingRoom" items="${meetingRoomList}">
       <div class="row mt-3 ms-2 d-flex align-items-center club-box" onclick="enterRoom(${meetingRoom.chatRoomNo})">
    <div class="col-2">
    <c:choose>
                 <c:when test="${meetingRoom.attachNo > 0}">
                    <img src="${pageContext.request.contextPath}/club/image?clubNo=${meetingRoom.clubNo}" class="rounded-circle" width="80" height="80">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/basic-profile.png" class="rounded-circle" width="80" height="80">
                </c:otherwise>
            </c:choose>  
    </div>
    <div class="col">
        <div class="col">
            <span class="clubname-text">${meetingRoom.meetingName}</span> 
        </div>
        <div class="col">
            <span class="explain-text">${meetingRoom.meetingLocation}</span> 
        </div>
    </div>
</div>
    </c:forEach>

<script>
    function enterRoom(chatRoomNo) {
        window.location.href = "/chat/enterRoom/" + chatRoomNo;
    }
    
    function hoverEffect(element) {
        element.style.backgroundColor = "#f0f0f0";
    }

    function removeHoverEffect(element) {
        element.style.backgroundColor = ""; // 원래 색상으로 되돌리기
    }
</script>
   
</body>


</html>



<jsp:include page="/WEB-INF/views/template/rightSidebar.jsp"></jsp:include>
