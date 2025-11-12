import 'package:dev_lib_getx/models/model_batch_get_data_1.dart';
import 'package:dev_lib_getx/models/model_batch_post_data_1.dart';
import 'package:dev_lib_getx/models/model_combined_step_1.dart';
import 'package:dev_lib_getx/models/model_get_with_params.dart';
import 'package:get/get.dart';

import '../../core/constants/api_config.dart';
import '../../core/repository/network_repository.dart';
import '../../core/services/logger_service.dart';
import '../../models/model_batch_get_data_2.dart';
import '../../models/model_batch_post_data_2.dart';
import '../../models/model_combined_step_2.dart';

enum ParamsData { failed, success, none, admin, user }

class ThirdLogic extends GetxController {
  final NetworkRepository networkRepo = Get.find<NetworkRepository>();

  Rx<ParamsData> batchGetData1 = ParamsData.success.obs;
  Rx<ParamsData> batchGetData2 = ParamsData.success.obs;
  Rx<ParamsData> batchPostData1 = ParamsData.success.obs;
  Rx<ParamsData> batchPostData2 = ParamsData.success.obs;

  Rx<ParamsData> combinedStep1 = ParamsData.success.obs;
  Rx<ParamsData> combinedStep2 = ParamsData.success.obs;

  Rx<ParamsData> getWithParams = ParamsData.none.obs;

  var apiResultString = "这里用来显示请求网络的结果".obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void setGetWithParams(ParamsData? value) {
    if (value != null) {
      getWithParams.value = value;
    }
  }

  void setCombinedData1(ParamsData? value) {
    if (value != null) {
      combinedStep1.value = value;
    }
  }

  void setCombinedData2(ParamsData? value) {
    if (value != null) {
      combinedStep2.value = value;
    }
  }

  void setBatchGetData1(ParamsData? value) {
    if (value != null) {
      batchGetData1.value = value;
    }
  }

  // (核心修复)
  //    (之前这里写的是 batchGetData1)
  void setBatchGetData2(ParamsData? value) {
    if (value != null) {
      batchGetData2.value = value;
    }
  }

  void setBatchPostData1(ParamsData? value) {
    if (value != null) {
      batchPostData1.value = value;
    }
  }

  // (核心修复)
  void setBatchPostData2(ParamsData? value) {
    if (value != null) {
      batchPostData2.value = value;
    }
  }

  Future<void> getDataWithParams() async {
    apiResultString.value = "";

    Map<String, dynamic> requestParam = {};
    var value = "";
    switch (getWithParams.value) {
      case ParamsData.admin:
        value = "admin";
        break;
      case ParamsData.user:
        value = "user";
        break;
      default:
        value = "";
        break;
    }
    requestParam["role"] = value;
    final resultData = await networkRepo.getData<List<ModelGetWithParams>>(
      ApiConfig.getDataWithParam,
      queryParameters: requestParam,
      fromJsonT: (json) => (json as List)
          .map((e) => ModelGetWithParams.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    apiResultString.value = resultData.toString();
  }

  Future<void> batchRequest() async {
    apiResultString.value = "";
    Map<String, dynamic> requestParam1 = {};
    if (batchGetData1.value == ParamsData.success) {
      requestParam1["response"] = true;
    } else {
      requestParam1["response"] = false;
    }

    Map<String, dynamic> requestParam2 = {};
    if (batchGetData2.value == ParamsData.success) {
      requestParam2["response"] = true;
    } else {
      requestParam2["response"] = false;
    }

    Map<String, dynamic> requestParam3 = {};
    if (batchPostData1.value == ParamsData.success) {
      requestParam3["response"] = true;
    } else {
      requestParam3["response"] = false;
    }

    Map<String, dynamic> requestParam4 = {};
    if (batchPostData2.value == ParamsData.success) {
      requestParam4["response"] = true;
    } else {
      requestParam4["response"] = false;
    }

    try {
      isLoading(true);
      errorMessage('');

      /// *不要* 'await' 它们
      var batchGetData1 = networkRepo.getData<ModelBatchGetData1>(
        ApiConfig.batchGetData1,
        queryParameters: requestParam1,
        fromJsonT: (json) =>
            ModelBatchGetData1.fromJson(json as Map<String, dynamic>),
        showLoading: true,
        showToast: false,
      );

      final batchGetData2 = networkRepo.getData<ModelBatchGetData2>(
        ApiConfig.batchGetData2,
        queryParameters: requestParam2,
        fromJsonT: (json) =>
            ModelBatchGetData2.fromJson(json as Map<String, dynamic>),
        showLoading: true,
        showToast: false,
      );

      final batchPostData1 = networkRepo.postData<ModelBatchPostData1>(
        parameter: requestParam3,
        ApiConfig.batchPostGetData1,
        fromJsonT: (json) =>
            ModelBatchPostData1.fromJson(json as Map<String, dynamic>),
        showLoading: true,
        showToast: false,
      );

      final batchPostData2 = networkRepo.postData<ModelBatchPostData2>(
        parameter: requestParam4,
        ApiConfig.batchPostGetData2,
        fromJsonT: (json) =>
            ModelBatchPostData2.fromJson(json as Map<String, dynamic>),
        showLoading: true,
        showToast: false,
      );

      //    'Future.wait' 会*同时*触发*所有*请求  并*等待*它们*全部*完成
      final results = await Future.wait([
        batchGetData1,
        batchGetData2,
        batchPostData1,
        batchPostData2,
      ]);

      final ModelBatchGetData1 result1 = results[0] as ModelBatchGetData1;
      final ModelBatchGetData2 result2 = results[1] as ModelBatchGetData2;
      final ModelBatchPostData1 result3 = results[2] as ModelBatchPostData1;
      final ModelBatchPostData2 result4 = results[3] as ModelBatchPostData2;
      // 如果代码执行到这里, 说明请求都已成功 (code == 200)

      apiResultString.value =
          "全部成功! \n结果1: $result1 \n结果2: $result2\n结果3: $result3\n结果4: $result4";
      logger.i(results);
    } on ApiException catch (e) {
      logger.e("[并行] 业务失败 (code != 200)", error: e);
      errorMessage(e.message);
      apiResultString.value = "请求失败: ${e.message}";
    } catch (e) {
      //    *必须* catch!
      //    (只要有*一个*请求发生*网络*  (错误[DioException],  或*其他*错误[解析错误],  就会*立即*跳到这里)
      logger.e("[并行] 失败 (网络/其他)", error: e);
      errorMessage(e.toString());
      apiResultString.value = "请求失败: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> combinedRequest() async {
    ModelCombinedStep2 modelCombinedStep2 = ModelCombinedStep2(
      method: 'method1',
      value: 'value1',
    );
    logger.i("modelCombinedStep2=>$modelCombinedStep2");

    apiResultString.value = "";
    Map<String, dynamic> requestParam1 = {};
    if (combinedStep1.value == ParamsData.success) {
      requestParam1["response"] = true;
    } else {
      requestParam1["response"] = false;
    }

    try {
      isLoading(true);
      errorMessage('');

      var combinedData1 = await networkRepo.postData<ModelCombinedStep1>(
        ApiConfig.combinedStep1,
        parameter: requestParam1,
        fromJsonT: (json) =>
            ModelCombinedStep1.fromJson(json as Map<String, dynamic>),
        showLoading: true,
        showToast: false,
      );
      apiResultString.value = "combinedData1=>$combinedData1";
      logger.i("combinedData1=>$combinedData1");

      Map<String, dynamic> requestParam2 = {};
      if (combinedStep1.value == ParamsData.success) {
        requestParam2["value"] = combinedData1.value;
      } else {
        requestParam2["value"] = "";
      }

      final combinedData2 = await networkRepo.postData<ModelCombinedStep2>(
        ApiConfig.combinedStep2,
        parameter: requestParam2,
        fromJsonT: (json) =>
            ModelCombinedStep2.fromJson(json as Map<String, dynamic>),
        showLoading: true,
        showToast: false,
      );
      apiResultString.value = "combinedData2=>${combinedData2}";
      logger.i("combinedData2=>$combinedData2");
    } on ApiException catch (e) {
      logger.e("combinedRequest", error: e);
      errorMessage(e.message);
      apiResultString.value = "combinedRequest请求失败: ${e.message}";
    } catch (e) {
      //    *必须* catch!
      //    (只要有*一个*请求发生*网络*  (错误[DioException],  或*其他*错误[解析错误],  就会*立即*跳到这里)
      logger.e("combinedRequest", error: e);
      errorMessage(e.toString());
      apiResultString.value = "combinedRequest: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }
}
