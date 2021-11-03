# GameLog

*게임 추천/기록 서비스 on iOS* | [소개 영상](https://youtu.be/uFUUKgeB_eU)

![](/README/Cover.png)


## 개요

### 배경
개인적으로 자신의 일상이나 발자취를 기록으로 남겨두는 행위를 자주 하는데, 주로 즐기는 문화생활인 게임에 있어서는 영화, 책, 음악과는 달리 보편화된 서비스가 존재하지 않는다. 현재 앱스토어에 올라와 있는 비슷한 서비스들을 살펴보면, 대부분 영어로만 제공이 되고 UI나 기록을 남기는 행동 자체가 굉장히 복잡한 형태로 이루어져 있어서 나는 단순한 형태의 디자인과 UX를 경험하는 것을 원하기 때문에 직접 서비스를 만들게 되었다.

### 목표
게임에 대한 정보를 제공해주는 IGDB API를 활용하여 선호하는 장르에 따른 게임 추천, 라이브러리와 위시리스트 제공, 사용자의 현재 게임 진행 상태 및 별점과 리뷰를 남길 수 있는 기능, 그리고 게임 검색 기능을 구현하는 것이 주된 목표이다.

### 관련 조사
게임에 대한 정보를 찾는 것이 가장 중요한 요소여서 이에 대한 조사를 먼저 시행하였다. RAWG와 비디오 게임 전용 인터넷 개인 방송 서비스인 트위치에서 제공하는 IGDB가 상용으로 사용하지 않는다면 무료로 사용하기에 적당했다. 하지만 RAWG는 한글에 대한 지원이 전무한 데에 반해, IGDB는 게임이 한글 제목을 데이터로 가지고 있어서 이쪽으로 선택하게 되었다.

UI, UX 디자인에 대해서는 도메인의 직관적인 경험에 대해서는 국내에서 가장 큰 리뷰 서비스인 「왓챠피디아」 를 사용해보며 조사를 진행하였고, 사용자의 간단한 접근과 경험에 대해서는 이것을 가장 효과적으로 표현했다고 생각하는 애플의 「App Store」 를 참고하였다.

## 프로젝트 구조

*UIKit 프레임워크의 기본적인 구조인 MVC 패턴이 아닌 Model, View, ViewController 간의 종속성을 줄이기 위하여 ViewModel을 추가한 MVVM 패턴을 적용하여 프로젝트를 진행하였다.*

![](/README/ClassDiagram.png)

홈 화면, 라이브러리 화면, 검색 화면, 게임 상세 화면에 대해서 각자 위와 같은 구조로 이루어져 있고, 위시리스트의 경우에는 라이브러리와 같은 형태로 구성되어 있어서 `ViewController`를 제외한 나머지는 같은 타입들을 사용하여 구성하였다.

`ViewController`에서 `ViewModel`에게 데이터에 대해 Fetch를 호출하면 해당 `Service`의 메서드를 통해 `NetworkRepository`로 가서 HTTP 통신을 하게 된다. 통신에 성공하여 정상적인 응답이 오면 다시 `Service`를 통해 `ViewModel`로 도착하게 되고, 이를 통해 `ViewModel`은 자신이 가진 `Model`의 인스턴스를 업데이트한다. 기존에 `ViewController`에는 `ViewModel`과 데이터바인딩을 통해 `View`의 업데이트 코드를 넣어두어 이를 통해 자연스례 `View`가 업데이트 되는 구조로 이루어져있다.

## UI/UX 구성

`TabBar` 위에 `NavigatiorController`위에 모든 `ViewController`가 쌓여있는 구조로 이루어져있고, 메인 색상은 `System.Indigo`로 하였으며, `NavigationBar` 같은 경우는 `LargeTitle`로 설정을 하고 사용자의 프로필 사진을 보여주는 버튼을 우측에 배치하는 UI로 구성하였다.

추가로 해당 어플리케이션 내의 네트워크 통신은 외부 라이브러리가 아닌 `Foundation` 프레임워크가 제공하는 `URLSession`을 직접 사용하였으며, 이미지를 불러오는 데에 있어서 Lazy Loading과 Operation cancel을 설정해두어 부하를 줄였다.

### 홈 화면

<img src="/README/Home.png" height="480">

인기 게임과 사용자가 선택한 장르에 따른 게임을 추천해서 보여주는 화면이다.

`CollectionView`를 `ComposionalLayout`으로 구성하였고, 필요한 `HeaderView`와 `Cell`에 대한 `View` 정의는 타입으로 나눠져있다. 이를 위해 `DiffableDataSource`와 `DiffableDataSourceSnapshot`을 `ViewModel`에 두어 모델 인스턴스의 변화에 따라서 `snapshot`이 property observer를 통해 적용되어 자동으로 `View`의 업데이트가 일어나는 구조이다.

### 라이브러리/위시리스트 화면

<img src="/README/Library.png" height="480">

`CollectionView`의 구조나 활용방법은 홈 화면과 동일하다.

다만 여기서는 `SectionHeader`가 스크롤에 따라 항상 보이도록 고정되어 있어야 하므로 해당 사항을 적용시켜주었고, `HeaderView` 안에는 정렬을 위한 두 가지 버튼이 있는데, **담은 순**을 터치하면 정렬 기준을 변경시키는 `AlertController`가 `ActionSheet` 형태로 출력이 되며, 선택을 하면 `ViewModel`을 업데이트하여 `View` 역시 받아온 데이터를 토대로 업데이트되는 구조로 이루어져있다.

라이브러리의 경우에는 각 게임 `Cell`의 상태가 `Todo`, `Doing`, `Done` 세 가지 이므로 이를 구분하기 위해 커버 이미지 하단에 `Label`을 표시하여 사용자가 구분하기 쉽게 하였다.

### 게임 상세 화면

<img src="/README/GameDetail.png" height="480">

상단의 스크린샷부터 별점까지의 `View`는 길이가 일정하므로 고정으로 두었고, 아래의 길어질 수 있는 리뷰와 게임 소개에 대한 `View`들은 `ScrollView`안에 `StackView`로 감싸도록 구성하였다.

스크린샷이 `StatusBar`와 `NavgiationBar` 모두를 덮는 구성으로 되어 있어 아무래도 기존 검은색 글씨는 시인성이 떨어지는 경우가 더 많아져 흰색으로 고정해 두었다.
`RightBarButton`을 터치하면 `AlertController`가 상태에 대한 `ActionSheet`를 출력하며, 이에 따라서 위시리스트, 혹은 라이브러리에 들어가게 되는데 게임 완료에 대한 상태는 없는 것을 확인할 수 있다.
이는 별점을 통해 어느 상태에 있든 완료로 변경할 수 있으며 완료가 되면 숨겨져있던 리뷰 버튼이 보여서 리뷰를 할 수 있다.

리뷰와 별점은 반드시 완료 상태여야 값이 존재할 수 있게 구현되어 있어서 바뀐다면 기존에 가지고 있던 정보를 사라지게 된다.
리뷰 작성 페이지는 `Modal`로 띄어지게 되며, 변경사항이 없다면 등록이 되지 않는다. 추가로 `FirstResponder` 설정을 해두어 바로 키보드가 켜지며, `NotificationCenter`의 알림을 통해 키보드의 유무에 `TextView`의 `Offset`을 변경시켜 사용자에게 더 나은 UI/UX를 제공한다.

### 검색 화면

<img src="/README/Search.png" height="480">

`SearchController`를 `navigationItem`에 넣어서 `SearchBar`를 터치했을 때, `NavigationBar`가 사라져서 더 나은 사용자 경험을 줄 수 있도록 하였고, `Delegate`를 통해서 `SearchBar`의 `Text`에 변화가 생기면 검색 API를 요청하여 결과를 업데이트 할 수 있도록 구성하였다. 여기서 `Cell`의 구조는 다른 `View`와는 다르게 검색의 결과를 더욱 잘 알아볼 수 있도록 Cover 이미지는 작게하고, 오른쪽에는 게임 이름을 두었다.
