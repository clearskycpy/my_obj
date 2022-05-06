<%--
  Created by IntelliJ IDEA.
  User: 小宇
  Date: 2022/5/3
  Time: 18:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学成教育</title>
    <link rel="stylesheet" href="xczxstyle.css">

</head>

<body>
<a href="${pageContext.request.contextPath}/index1.do">login</a>
<br>
<br>
<div class="header w">
    <div class="log"><img src="image/logo.docx.png" alt=""></div>
    <div class="nav">
        <ul>
            <li><a href="#">首页</a> </li>
            <li><a href="#">课程</a></li>
            <li><a href="#">职业规划</a></li>
        </ul>
    </div>
    <div class="search">
        <input type="text" value="输入关键词">
        <button></button>
    </div>
    <div class="user">
        <img src="image/tx.png" alt="">
        qq-lilei
    </div>
</div>
<!-- 结束头部标签 -->
<div class="banner">
    <div class="w">
        <div class="cbl">
            <ul>
                <li><a href="#">前端开发 <span> &gt;</span></a></li>
                <li><a href="#">后端开发<span> &gt;</span></a></li>
                <li><a href="#">移动开发<span> &gt;</span></a></li>
                <li><a href="#">人工智能<span> &gt;</span></a></li>
                <li><a href="#">商业预测<span> &gt;</span></a></li>
                <li><a href="#">云计算&大数据<span> &gt;</span></a></li>
                <li><a href="#">运输&从运算<span> &gt;</span></a></li>
                <li><a href="#">UI设计<span> &gt;</span></a></li>
                <li><a href="#">产品<span> &gt;</span></a></li>
            </ul>
        </div>
        <div class="course">
            <h2>我的课程表</h2>
            <div class="bd">
                <ul>
                    <li>
                        <h4>继续学习 程序语言设计</h4>
                        <p>正在学习-使用对象</p>
                    </li>
                    <li>
                        <h4>继续学习 程序语言设计</h4>
                        <p>正在学习-使用对象</p>
                    </li>
                    <li>
                        <h4>继续学习 程序语言设计</h4>
                        <p>正在学习-使用对象</p>
                    </li>
                </ul>
                <a href="#" class="qbkc">全部课程</a>
            </div>
        </div>
    </div>
</div>
<div class="common w">
    <h3>精品推荐</h3>
    <ul>
        <li><a href="#">JQuery</a>
        </li>
        <li><a href="#">Spark</a>
        </li>
        <li><a href="#">MYSQL</a>
        </li>
        <li><a href="#">JavaWeb</a>
        </li>
        <li><a href="#">MySQL</a>
        </li>
        <li><a href="#">JavaWeb</a></li>

    </ul>
    <a href="#" class="xgxq">修改兴趣</a>
</div>
<div class="jptj w">
    <div class="box-hd">
        <h3>精品推荐</h3>
        <a href="#">查看全部</a>
    </div>
    <div class="box-bd">
        <ul class="clearfix">
            <li>
                <img src="image/图层 133.png" alt="">
                <h4>Think PHP 5.0 博客系统实战项目演练</h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li>
                <img src="image/图层 135.png" alt="">
                <h4>Android 网络图片加载框架详解 </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li>
                <img src="image/图层 136.png" alt="">
                <h4>
                    Angular 2 最新框架+主流技术+项目实战
                </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li><img src="image/图层 137.png" alt="">
                <h4>
                    Android Hybrid APP开发实战 H5+原生！
                </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li><img src="image/图层 137.png" alt="">
                <h4>
                    Android Hybrid APP开发实战 H5+原生！
                </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>

            <li><img src="image/图层 133.png" alt="">
                <h4>Think PHP 5.0 博客系统实战项目演练</h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li> <img src="image/图层 135.png" alt="">
                <h4>Android 网络图片加载框架详解 </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li><img src="image/图层 136.png" alt="">
                <h4>
                    Angular 2 最新框架+主流技术+项目实战
                </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
            <li><img src="image/图层 137.png" alt="">
                <h4>
                    Android Hybrid APP开发实战 H5+原生！
                </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>

            <li><img src="image/图层 137.png" alt="">
                <h4>
                    Android Hybrid APP开发实战 H5+原生！
                </h4>
                <div class="info"><span>高级</span>~1125人在学习</div>
            </li>
        </ul>
    </div>


</div>
<div class="foot">
    <div class="w">
        <div class="copyright">
            <img src="image/logo.docx.png" alt="">
            <p>学成在线致力于普及中国最好的教育它与中国一流大学和机构合作提供在线课程。<br>
                © 2017年XTCG Inc.保留所有权利。-沪ICP备15025210号</p>
            <a href="#" class="app">下载app</a>

        </div>
        <div class="links">
            <dl>
                <dt><a href="#">关于学成网</a></dt>
                <dt><a href="#">关于</a>
                </dd>
                <dd><a href="#">管理团队</a>
                </dd>
                <dd><a href="#">工作机会</a>
                </dd>
                <dd><a href="#">客户服务</a>
                </dd>
                <dd><a href="#">帮助</a></dd>
            </dl>
            <dl>
                <dt><a href="#">关于学成网</a></dt>
                <dt><a href="#">关于</a>
                </dd>
                <dd><a href="#">管理团队</a>
                </dd>
                <dd><a href="#">工作机会</a>
                </dd>
                <dd><a href="#">客户服务</a>
                </dd>
                <dd><a href="#">帮助</a></dd>
            </dl>
            <dl>
                <dt><a href="#">关于学成网</a></dt>
                <dt><a href="#">关于</a>
                </dd>
                <dd><a href="#">管理团队</a>
                </dd>
                <dd><a href="#">工作机会</a>
                </dd>
                <dd><a href="#">客户服务</a>
                </dd>
                <dd><a href="#">帮助</a></dd>
            </dl>
        </div>
    </div>
</div>
</body>
</html>
