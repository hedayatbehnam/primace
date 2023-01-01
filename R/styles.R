#' style of html
#' @param tags tags for general use for various element
#' @param htmlParam which html parameters to referes styles to
#' @export
style_ref <- function(tags, htmlParam) {
    tags[[htmlParam]]('
      .content-wrapper, .right-side {
         background-color: ghostwhite;
      }
      .title {
        font-size : 26px;
        font-weight:bold;
        text-align:center;
        background-color: white;
        boder: none;
        box-shadow: 0px 0px 20px 1px rgba(0,0,0,.2);
        border-radius:5px;
        align-items:center;
      }
      .home-box-title {
        font-size : 20px;
        text-align:center;
        background-color: #e6e6f5;
        boder: none;
        box-shadow: 0px 0px 20px 1px rgba(0,0,0,.2);
        border-radius:5px;
        align-items:center;
      }
      .login-box {
        float: right;
        right:10px;
        padding:0;
        margin:0;
        padding-top:15px;
      }
      .abstract-text {
        width:80%; 
        margin-top:0px; 
        font-size:15px;
      }
      img {
        margin-top:80px;
        margin-bottom: 20px;
      }
      .thc-logo-text { 
        font-size:24px;
        font-weight: bold;
      }
      .thc-logo-subtext {
        font-size:18px;
        margin-bottom: 80px;
      }
      .predict-text {
        font-size:17px;
        width:80%;
      }
      .alarm {
        color:red;
        font-size:16px;
        font-weight:bold;
      }
     .skin-purple .main-sidebar {
        box-shadow: 1px 1px 1px 1px rgba(0,0,0,.8);
     }
     #loadmessage {
        position: fixed;
        top: 0px;
        left: 0px;
        width: 100%;
        padding: 5px 0px 5px 0px;
        text-align: center;
        font-weight: bold;
        font-size: 100%;
        color: #000000;
        background-color: #CCFF66;
        z-index: 105;
      }
      @media only screen and (max-width:602px){
      .home-title {
        font-size : 18px;
        width:100%;
        transform:translate(0,0);
      }
      .predict-text {
        font-size:14px;
        width:100%;
      }
      .abstract-text{
        width:100%; 
        margin-top:0px; 
        font-size:15px;
      }
      }
      @media only screen and (max-width:980px){
      .home-title {
          font-size : 18px;
          width:100%;
          transform:translate(0,0);
      }
      .predict-text {
        font-size:14px;
        width:100%;
      }
      .abstract-text {
        width:100%; 
        margin-top:0px; 
        font-size:15px;
      }
      }                   
')
}