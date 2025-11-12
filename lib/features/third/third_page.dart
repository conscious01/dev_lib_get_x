import 'package:dev_lib_getx/features/third/third_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThirdPage extends GetView<ThirdLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ThirdPage Title")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildGetWithParamsViews(),
                  _buildBatchRequestViews(),
                  _buildCombinedRequestViews(),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(12),
            child: Obx(() {
              return Text(
                controller.apiResultString.value,
                style: TextStyle(color: Colors.white),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup({
    required String title,
    required ParamsData groupValue,
    required ValueChanged<ParamsData?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRadioOption(
              title: "Success (成功)",
              value: ParamsData.success,
              groupValue: groupValue,
              onChanged: onChanged,
            ),

            SizedBox(width: 20.w),

            _buildRadioOption(
              title: "Failed (失败)",
              value: ParamsData.failed,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGetParamsGroup({
    required String title,
    required ParamsData groupValue,
    required ValueChanged<ParamsData?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _buildRadioOption(
                title: "NONE",
                value: ParamsData.none,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),

            Expanded(
              child: _buildRadioOption(
                title: "admin",
                value: ParamsData.admin,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),

            Expanded(
              child: _buildRadioOption(
                title: "user",
                value: ParamsData.user,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String title,
    required ParamsData value,
    required ParamsData groupValue,
    required ValueChanged<ParamsData?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<ParamsData>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
            ),

            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildGetParamsSelections() {
    return Obx(
      () => ListView(
        shrinkWrap: true, // ✅ 关键
        physics: NeverScrollableScrollPhysics(), // ✅ 禁止内部滚动
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        children: [
          SizedBox(height: 10.h),
          _buildGetParamsGroup(
            title: "GetMethod with Params",
            groupValue: controller.getWithParams.value,
            onChanged: controller.setGetWithParams,
          ),

          Divider(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildBatchSelections() {
    return Obx(
      () => ListView(
        shrinkWrap: true, // ✅ 关键
        physics: NeverScrollableScrollPhysics(), // ✅ 禁止内部滚动
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        children: [
          SizedBox(height: 10.h),
          _buildRadioGroup(
            title: "批量获取数据 1 (Batch Get 1)",
            groupValue: controller.batchGetData1.value,
            onChanged: controller.setBatchGetData1,
          ),

          Divider(height: 1.h),
          SizedBox(height: 10.h),
          _buildRadioGroup(
            title: "批量获取数据 2 (Batch Get 2)",
            groupValue: controller.batchGetData2.value,
            onChanged: controller.setBatchGetData2,
          ),

          Divider(height: 8.h),
          SizedBox(height: 10.h),
          _buildRadioGroup(
            title: "批量提交数据 1 (Batch Post 1)",
            groupValue: controller.batchPostData1.value,
            onChanged: controller.setBatchPostData1,
          ),

          Divider(height: 8.h),

          _buildRadioGroup(
            title: "批量提交数据 2 (Batch Post 2)",
            groupValue: controller.batchPostData2.value,
            onChanged: controller.setBatchPostData2,
          ),
          Divider(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildCombinedSelections() {
    return Obx(
      () => ListView(
        shrinkWrap: true, // ✅ 关键
        physics: NeverScrollableScrollPhysics(), // ✅ 禁止内部滚动
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        children: [
          _buildRadioGroup(
            title: "组合请求 1 (Combined Step1)",
            groupValue: controller.combinedStep1.value,
            onChanged: controller.setCombinedData1,
          ),

          Divider(height: 8.h),

          _buildRadioGroup(
            title: "组合请求 2 (Combined Step2)",
            groupValue: controller.combinedStep2.value,
            onChanged: controller.setCombinedData2,
          ),
          Divider(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildBatchRequestViews() {
    return Container(
      margin: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildBatchSelections(),
          ElevatedButton(
            onPressed: () {
              controller.batchRequest();
            },
            child: Text('提交批量请求'),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildCombinedRequestViews() {
    return Container(
      margin: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow.shade900, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCombinedSelections(),
          ElevatedButton(
            onPressed: () {
              controller.combinedRequest();
            },
            child: Text('组合网络请求'),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildGetWithParamsViews() {
    return Container(
      margin: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildGetParamsSelections(),
          ElevatedButton(
            onPressed: () {
              controller.getDataWithParams();
            },
            child: Text('Get Data With Params'),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
