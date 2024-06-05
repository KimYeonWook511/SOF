package board;
// DB에 있는 데이터를 DTO로 가져옴
public class Board {
	private int no, viewCount; // 게시판 번호, 조회수
	private String title, addr, type, price, content, writer, writeDate; // 제목, 주소, 분류, 가격, 내용, 작성자, 작성일
	private String imgName, imgRealName;

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}
	
	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
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

	public int getViewCount() {
		return viewCount;
	}

	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
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
