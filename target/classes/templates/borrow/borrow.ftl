<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <title>借阅列表</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx!}/assets/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${ctx!}/assets/css/font-awesome.css?v=4.4.0" rel="stylesheet">

    <link href="${ctx!}/assets/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">

    <link href="${ctx!}/assets/css/animate.css" rel="stylesheet">
    <link href="${ctx!}/assets/css/style.css?v=4.1.0" rel="stylesheet">


</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content  animated fadeInRight">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox ">
                    <div class="ibox-title">
                        <h5>借阅管理</h5>
                    </div>
                    <div class="ibox-content">
                        <p>
                        	<@shiro.hasPermission name="system:borrow:add">
                        		<button class="btn btn-success " type="button" onclick="add();"><i class="fa fa-plus"></i>&nbsp;添加</button>
                        	</@shiro.hasPermission>
                            <@shiro.hasPermission name="system:borrow:add">
                                <button class="btn btn-success " type="button" onclick="return1();"><i class="fa fa-plus"></i>&nbsp;还书</button>
                            </@shiro.hasPermission>

                        </p>
                        <hr>
                        <div class="row row-lg">
		                    <div class="col-sm-12">
		                        <!-- Example Card View -->
		                        <div class="example-wrap">
		                            <div class="example">
		                            	<table id="table_list"></table>
		                            </div>
		                        </div>
		                        <!-- End Example Card View -->
		                    </div>
	                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 全局js -->
    <script src="${ctx!}/assets/js/jquery.min.js?v=2.1.4"></script>
    <script src="${ctx!}/assets/js/bootstrap.min.js?v=3.3.6"></script>

	<!-- Bootstrap table -->
    <script src="${ctx!}/assets/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="${ctx!}/assets/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="${ctx!}/assets/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>

    <!-- Peity -->
    <script src="${ctx!}/assets/js/plugins/peity/jquery.peity.min.js"></script>

    <script src="${ctx!}/assets/js/plugins/layer/layer.min.js"></script>

    <!-- 自定义js -->
    <script src="${ctx!}/assets/js/content.js?v=1.0.0"></script>

    <!-- Page-Level Scripts -->
    <script>
        $(document).ready(function () {
        	//初始化表格,动态从服务器加载数据
			$("#table_list").bootstrapTable({
			    //使用get请求到服务器获取数据
			    method: "POST",
			    //必须设置，不然request.getParameter获取不到请求参数
			    contentType: "application/x-www-form-urlencoded",
			    //获取数据的Servlet地址
			    url: "${ctx!}/borrowCtrl/list",
			    //表格显示条纹
			    striped: true,
			    //启动分页
			    pagination: true,
			    //每页显示的记录数
			    pageSize: 10,
			    //当前第几页
			    pageNumber: 1,
			    //记录数可选列表
			    pageList: [5, 10, 15, 20, 25],
			    //是否启用查询
			    search: false,
			    //是否启用详细信息视图
			    detailView:false,
                sortName:"borrowId",
                sortOrder:"desc",
			    detailFormatter:detailFormatter,
			    //表示服务端请求
			    sidePagination: "server",
			    //设置为undefined可以获取pageNumber，pageSize，searchText，sortName，sortOrder
			    //设置为limit可以获取limit, offset, search, sort, order
			    queryParamsType: "undefined",
			    //json数据解析
			    responseHandler: function(res) {
			        return {
			            "rows": res.content,
			            "total": res.totalElements
			        };
			    },
			    //数据列
			    columns: [{
			        title: "实际ID",
			        field: "borrowId",
			        sortable: true,
                    visible:false
			    },{
                    title: "ID",
                    field: "table_id",
                    formatter: function (value, row, index) {
                        return index+1;
                    }
                },{
			        title: "借阅者RFID",
			        field: "userId"
			    },{
                    title: "借阅书籍RFID",
                    field: "bookRfid"
                },{
			        title: "借阅时间",
			        field: "borrowTime"
			    },{
			        title: "应还时间",
			        field: "returnTime"
			    },{
			        title: "应还位置",
			        field: "returnLocation"
			    },{
			        title: "归还状态",
			        field: "status",
                    formatter: function(value, row, index) {
                        if (value == '0')
                            return '<span class="label label-info">未归还</span>';
                        if (value == '1')
                        	return '<span class="label label-primary">已归还</span>';
                        return '<span class="label label-warning">逾期</span>';
                    }
			    },{
			        title: "实际归还时间",
			        field: "actualTime"
			    },{
                    title: "实际归还位置",
                    field: "actualLocation"
                },{
                    title: "是否欠费",
                    field: "isPay",
                    formatter: function(value, row, index) {
                        if (value == '0')
                            return '<span class="label label-primary">否</span>';
						return '<span class="label label-warning">是</span>';
                    }
                },{
                    title: "欠款金额",
                    field: "amount"
                },{
                    title: "订单是否完成",
                    field: "isFinish",
                    formatter: function(value, row, index) {
                        if (value == '0')
                            return '<span class="label label-warning">否</span>';
                        return '<span class="label label-primary">是</span>';
                    }
                },{
                    title: "更新时间",
                    field: "updateTime"
                },{
			        title: "操作",
			        field: "empty",
                    formatter: function (value, row, index) {
                    	var operateHtml = '<@shiro.hasPermission name="system:borrow:edit"><button class="btn btn-primary btn-xs" type="button" onclick="edit(\''+row.borrowId+'\')"><i class="fa fa-edit"></i>&nbsp;修改</button> &nbsp;</@shiro.hasPermission>';
                    	operateHtml = operateHtml + '<@shiro.hasPermission name="system:borrow:deleteBatch"><button class="btn btn-danger btn-xs" type="button" onclick="del(\''+row.borrowId+'\')"><i class="fa fa-remove"></i>&nbsp;删除</button> &nbsp;</@shiro.hasPermission>';
                        return operateHtml;
                    }
			    }]
			});
        });

        function edit(id){
        	layer.open({
        	      type: 2,
        	      title: '修改借阅表单',
        	      shadeClose: true,
        	      shade: false,
        	      area: ['893px', '600px'],
        	      content: '${ctx!}/borrowCtrl/edit/' + id,
        	      end: function(index){
        	    	  $('#table_list').bootstrapTable("refresh");
       	    	  }
        	    });
        }
        function add(){
            layer.open({
                type: 2,
                title: '借书表单',
                shadeClose: true,
                shade: false,
                area: ['893px', '600px'],
                content: '${ctx!}/borrowCtrl/add',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function return1(){
            layer.open({
                type: 2,
                title: '还书表单',
                shadeClose: true,
                shade: false,
                area: ['893px', '600px'],
                content: '${ctx!}/borrowCtrl/return1',
                end: function(index){
                    $('#table_list').bootstrapTable("refresh");
                }
            });
        }
        function del(id){
        	layer.confirm('确定删除吗?', {icon: 3, title:'提示'}, function(index){
        		$.ajax({
    	    		   type: "POST",
    	    		   dataType: "json",
					   url: "${ctx!}/borrowCtrl/deleteBorrow/" + id,
    	    		   success: function(msg){
	 	   	    			layer.msg(msg.message, {time: 2000},function(){
	 	   	    				$('#table_list').bootstrapTable("refresh");
	 	   	    				layer.close(index);
	 	   					});
    	    		   }
    	    	});
       		});
        }

        function detailFormatter(index, row) {
	        var html = [];
	        html.push('<p><b>描述:</b> ' + row.description + '</p>');
	        return html.join('');
	    }

    </script>




</body>

</html>
