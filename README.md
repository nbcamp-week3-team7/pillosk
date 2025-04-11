

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

## **📂 파일 구조**

```
PilloskProject
├── Extensions
│   └── UIView+Extensions.swift  // UIView 관련 확장 기능 구현
├── Models
│   ├── Data.swift               // 데이터 모델 정의
│   ├── DataService.swift        // 데이터 관리 서비스
│   └── OrderSummaryData.swift   // 주문 요약 데이터 모델
├── Resources
│   ├── Assets.xcassets          // 이미지 및 앱 리소스 파일
│   ├── data.json                // 의약품 데이터 저장
│   └── Info.plist               // 앱 설정 파일
├── Utils
│   └── Constants.swift          // 앱에서 사용하는 상수 정의
├── ViewControllers
│   └── ViewController.swift     // 메인 뷰 컨트롤러
├── Views
│   ├── CategoryView.swift       // 카테고리별 UI 구현
│   ├── MenuListView.swift       // 상품 목록 UI 구현
│   ├── OrderSummaryTableView... // 주문 요약 테이블 뷰
│   ├── OrderSummaryView.swift   // 주문 요약 UI
│   └── ProductCell.swift        // 상품 셀 UI
├── AppDelegate.swift            // 앱 델리게이트 파일
├── SceneDelegate.swift          // 씬 델리게이트 파일
├── LaunchScreen.storyboard      // 런치 화면
└── Package Dependencies
    └── SnapKit 5.7.1            // 레이아웃 구성 라이브러리

```

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

<table>
  <tr>
    <td><strong>기본 메인 화면</strong></td>
    <td><strong>메뉴 변경 화면</strong></td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/0963f18e-2b20-4b82-8749-2138ba2cb8ab" alt="기본 메인 화면" width="300"/>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/a24f5d6d-0e12-4cc0-9ba4-a429ef103fcf" alt="메뉴 변경 화면" width="300"/>
    </td>
  </tr>
  <tr>
    <td><strong>장바구니 화면</strong></td>
    <td><strong>결제 화면</strong></td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/1b26c99c-7a58-45cc-ae1a-836a51b21628" alt="장바구니 화면" width="300"/>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/4f2d99b4-52a3-44b2-a02c-a87424d3250d" alt="결제 화면" width="300"/>
    </td>
  </tr>
</table>

---

## **📚 참고 자료**
- [노션 프로젝트 문서](https://teamsparta.notion.site/7-1ce2dc3ef5148057ac4cea70222d7f32)  
- [깃허브 저장소](https://github.com/nbcamp-week3-team7/pillosk.git)  

---
