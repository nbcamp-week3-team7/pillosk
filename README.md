

# **Pillosk**

## **📱 프로젝트 개요**
Pillosk는 사용자가 카테고리별로 의약품을 선택하고, 구매할 수 있는 간단한 의약품 쇼핑 앱입니다.  
이 앱은 직관적인 UI를 제공하며, SnapKit을 활용하여 iOS 환경에서 효율적으로 레이아웃을 구성했습니다.

---

## **🎯 구현 목표**
1. **사용자 친화적인 UI/UX**  
   - 직관적인 카테고리별 의약품 선택 화면 제공.  
   - 사용자가 선택한 상품을 장바구니에 담아 결제 금액을 확인할 수 있도록 구현.  

2. **필수 기능 구현**  
   - 카테고리별 상품 나열 및 선택 기능.  
   - 장바구니 기능 및 결제 금액 계산.  
   - SnapKit을 이용한 레이아웃 구성.  

---

## **✅ 필수 구현 사항**
- [x] 카테고리별 상품 나열 및 선택 기능.  
- [x] 장바구니에 담긴 상품의 개수 및 총 금액 표시.  
- [x] 상품 추가 및 삭제 기능.  
- [x] SnapKit을 활용한 UI 레이아웃 구성.  
- [x] 데이터 모델링 및 JSON 파일을 활용한 데이터 관리.  

---

## **🎨 사용한 색상 코드**
- **메인 색상**: `#007AFF` (애플 블루)  
- **배경 색상**: `#FFFFFF` (화이트)  
- **텍스트 색상**: `#000000` (블랙)  
- **버튼 색상**: `#F2F2F2` (라이트 그레이)  

---

## **✨ UI 특징**
1. **카테고리별 상품 나열**  
   - 상단 탭을 통해 감기/피로, 두통/통증, 소화/위장 등 카테고리를 선택 가능.  
   - 각 카테고리별로 상품이 카드 형태로 나열됨.  

2. **장바구니 기능**  
   - 상품을 선택하면 장바구니에 추가되며, 하단에 총 금액과 상품 개수가 표시됨.  
   - 상품 개수 조절 및 삭제 기능 제공.  

3. **결제 버튼**  
   - 하단의 결제 버튼을 통해 총 금액 확인 가능.  

---

## **👨‍💻 팀원 역할**

### **상단 카테고리 바 (CategoryView)**
- **담당**: 윤주형  
- **작업 파일**: `CategoryView.swift`  
- **내용**: 카테고리 버튼 UI 및 클릭 이벤트 처리  

---

### **중앙 메뉴 화면 (MenuListView)**
- **담당**: 김신영  
- **작업 파일**: `MenuListView.swift`, `ProductCell.swift`  
- **내용**: 메뉴 리스트 페이징 처리 및 UI 구현  

---

### **주문 내역 및 결제 버튼 (OrderSummaryView)**
- **담당**: 이부용  
- **작업 파일**: `OrderSummaryView.swift`, `OrderSummaryData.swift`, `OrderSummaryTableViewCell.swift`  
- **내용**: 주문 내역 표시 및 결제 버튼 동작 구현  

---

## **📂 주요 파일 설명**

### **1. Data.swift**
- **역할**: 의약품 데이터를 나타내는 데이터 모델 정의.  
- **주요 로직**:  
  - `Product` 구조체를 통해 상품의 이름, 가격, 카테고리 등을 관리.  
  - JSON 디코더를 통해 데이터를 로드할 때 사용하는 모델.  

### **2. DataService.swift**
- **역할**: 의약품 데이터를 관리하고 제공하는 서비스.  
- **주요 로직**:  
  - `loadData()` 함수로 JSON 파일에서 데이터를 읽어와 `Product` 배열로 반환.  
  - 데이터 로드 실패 시 빈 배열 반환.  

### **3. OrderSummaryData.swift**
- **역할**: 장바구니에 담긴 상품 데이터를 관리.  
- **주요 로직**:  
  - 선택된 상품의 개수와 총 금액을 계산.  
  - 상품 추가 및 삭제 로직 포함.  

### **4. CategoryView.swift**
- **역할**: 카테고리별 상품을 나열하는 UI 구현.  
- **주요 로직**:  
  - SnapKit을 활용한 레이아웃 구성.  
  - 탭 선택 시 해당 카테고리에 맞는 상품만 표시.  

### **5. MenuListView.swift**
- **역할**: 상품 목록을 보여주는 UI 구현.  
- **주요 로직**:  
  - `UICollectionView`를 사용하여 상품 리스트를 카드 형태로 표시.  
  - 상품 선택 시 장바구니에 추가하는 이벤트 처리.  

### **6. OrderSummaryView.swift**
- **역할**: 장바구니 요약 화면 구현.  
- **주요 로직**:  
  - 상품 개수와 총 금액 표시.  
  - 상품 개수 조절 및 삭제 기능 구현.  

### **7. ProductCell.swift**
- **역할**: 상품 카드 UI를 나타내는 셀 구현.  
- **주요 로직**:  
  - 상품 이미지, 이름, 가격 등을 표시.  
  - SnapKit을 활용한 레이아웃 구성.  

### **8. Constants.swift**
- **역할**: 앱에서 사용하는 상수를 관리.  
- **주요 내용**:  
  - 색상, 폰트, 여백 등의 상수 정의.  

---

## **🖼️ 앱 구현 화면**
### **1. 기본 메인 화면**
![기본 메인 화면](https://file.notion.so/f/f/e16ac594-b9fc-4917-a7e0-a205f96f6878/8443b2f6-871b-4c0f-b5d0-6d3a724a50ed/Simulator_Screenshot_-_iPhone_16_Pro_-_2025-04-10_at_18.42.37.png?table=block&id=1d16b554-2f29-8001-8746-cb10dced03dc&spaceId=e16ac594-b9fc-4917-a7e0-a205f96f6878&expirationTimestamp=1744300800000&signature=Smp22eJZuBcnkOhnnysNWmsx1PSZBkFDULbyRvV91Pc&downloadName=Simulator+Screenshot+-+iPhone+16+Pro+-+2025-04-10+at+18.42.37.png)

### **2. 메뉴 변경 화면**
![메뉴 변경 화면](https://file.notion.so/f/f/e16ac594-b9fc-4917-a7e0-a205f96f6878/6a65faa5-822f-4d51-a05b-b79c41689d9b/Simulator_Screenshot_-_iPhone_16_Pro_-_2025-04-10_at_18.43.01.png?table=block&id=1d16b554-2f29-8055-b557-cc5d1c0820ad&spaceId=e16ac594-b9fc-4917-a7e0-a205f96f6878&expirationTimestamp=1744300800000&signature=hbMdzzFmWm3MIjyDevauWIydaomtgqox4LgJmp7XXVo&downloadName=Simulator+Screenshot+-+iPhone+16+Pro+-+2025-04-10+at+18.43.01.png)

### **3. 장바구니 추가 화면**
![장바구니 추가 화면](https://file.notion.so/f/f/e16ac594-b9fc-4917-a7e0-a205f96f6878/33fa6bcf-ee26-4885-8cb9-b8c858cfff9a/Simulator_Screenshot_-_iPhone_16_Pro_-_2025-04-10_at_18.43.24.png?table=block&id=1d16b554-2f29-8030-8d65-c5a4234382bc&spaceId=e16ac594-b9fc-4917-a7e0-a205f96f6878&expirationTimestamp=1744300800000&signature=PQSYVeBy7Ih8KNeuBtR9vuPctgM9pg0h8zAinSk4ESY&downloadName=Simulator+Screenshot+-+iPhone+16+Pro+-+2025-04-10+at+18.43.24.png)

### **4. 결제 Alert창 화면**
![결제 Alert창 화면](https://file.notion.so/f/f/e16ac594-b9fc-4917-a7e0-a205f96f6878/4889f6fb-cc25-45f4-8ce1-3431ebaf33ff/Simulator_Screenshot_-_iPhone_16_Pro_-_2025-04-10_at_18.43.33.png?table=block&id=1d16b554-2f29-80b8-8b64-f596f95746e5&spaceId=e16ac594-b9fc-4917-a7e0-a205f96f6878&expirationTimestamp=1744300800000&signature=oO4AtlbGHtrIkmXLbalX952KniYNYrfeTWY_Kdgvnhk&downloadName=Simulator+Screenshot+-+iPhone+16+Pro+-+2025-04-10+at+18.43.33.png)

---

## **📚 참고 자료**
- [노션 프로젝트 문서](https://teamsparta.notion.site/7-1ce2dc3ef5148057ac4cea70222d7f32)  
- [깃허브 저장소](https://github.com/nbcamp-week3-team7/pillosk.git)  

---
