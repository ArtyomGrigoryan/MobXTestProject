/* Код, для кнопки "Назад" */
function goBack() {
    window.history.back();
}

/* Скроем меню */
var menu = document.getElementsByClassName('layout-header js-layout-header fixed-top')[0];
menu.style.visibility = 'hidden';

/* Покажем иконку Фаберлик со стрелкой назад */
var body = document.getElementsByTagName('body')[0];
body.insertAdjacentHTML('afterbegin', '<div class="fon"><div class="arrow"><input type="image" id="left-arrow" width="60" height="30" onclick="goBack()" src=""></div><div class="fablogo"><a href="https://new.faberlic.com/"><img id="faberlic" src="" width="100" height="30"></a></div></div>');

/* Покажем менюшки */
var header_down = document.getElementsByClassName('fon')[0];
header_down.insertAdjacentHTML('afterend', '<ul><li><a class="side-nav__enter d-flex ml-xl-2 js-side-menu__open" href="javascript:void(0)"><img src="" id="menu" width="30" height="30"></a></li><li><a href="https://new.faberlic.com/ru/"><img id="littleFaberlic" src="left.png" width="60" height="30"></a></li><li style="float:right"><a id="auth-link" class="js-login-link" href="javascript:void(0)" data-url="/ru/login/authform"><img src="" id="profile" width="30" height="30"></a></li><li style="float:right"><a href="https://new.faberlic.com/ru/cart"><img id="cart" src="" width="30" height="30"></a></li><li style="float:right"><a href="/ru/catalog/flash"><img id="book" src="" width="30" height="30"></a></li></ul>');

/* Скроем голубой квадрат */
var blue = document.getElementsByClassName('onboarding-trigger js-onboarding-trigger d-flex j-content-center a-items-center')[0];
blue.style.visibility = 'hidden';
