package review;
// DB에 있는 데이터를 DTO로 가져옴
public class Review {
	private int no, restNo; // 리뷰 번호, 음식점 번호
	private String title, content, writer, writeDate; // 제목, 내용, 작성자, 작성일
	private String imgName, imgRealName;

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}
	
	public int getRestNo() {
		return restNo;
	}
	
	public void setRestNo(int restNo) {
		this.restNo = restNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}
	
	public String getRepContent() {
		return content.replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;");
	}
	
	public void setContent(String content) {
		this.content = content;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getWriteDate() {
		return writeDate;
	}

	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}

	public String getImgName() {
		return imgName;
	}

	public void setImgName(String imgName) {
		this.imgName = imgName;
	}

	public String getImgRealName() {
		return imgRealName;
	}

	public void setImgRealName(String imgRealName) {
		this.imgRealName = imgRealName;
	}
}
