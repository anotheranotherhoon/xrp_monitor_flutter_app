import 'dart:io';
import 'dart:typed_data';

import 'package:xrp_monitor/service/file_service/file_api_service.dart';
import 'package:xrp_monitor/service/file_service/models/api_get_pre_sign_params.dart';
import 'package:xrp_monitor/service/file_service/models/api_get_pre_sign_response.dart';
import 'package:xrp_monitor/service/file_service/models/attachment_file.dart';
import 'package:xrp_monitor/service/file_service/models/attachment_info.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

enum PickType{
  gallery,
  camera
}

class FileService {
  int limitSize = 100 * 1024 * 1024; //100MB

  Future<ApiGetPreSignResponseBody?> _getPreSignUrl({required AttachmentFile file, required int key}) async {
    ApiGetPreSignParams params = ApiGetPreSignParams(containerType: file.type, ownerIdx: key, contentType: file.mime, fileName: file.name);
    final response = await FileApiService().getPreSignUrl(params);
    return response;
  }

  String _getRandomFileName(name) {
    var idx = name.lastIndexOf('.');
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = 'j$timestamp' + name.substring(idx); //TODO : 프로젝트 마다 앞 문자는 변경필요.
    return fileName;
  }

  Future<bool> _uploadFile(AttachmentFile attachmentFile, String presignedUrl) async {
    try {
      final bytes = await File(attachmentFile.url).readAsBytes();
      // S3 버킷에 이미지 업로드 요청
      final uploadImageResponse = await http.put(
        Uri.parse(presignedUrl),
        headers: {
          'Content-Type': attachmentFile.mime,
        },
        body: bytes,
      );

      if (uploadImageResponse.statusCode == 200) {
        return true;
      } else {
        print('Failed to upload a image: ${uploadImageResponse.body}');
        return false;
      }
    } catch (e) {
      print('Failed to upload a image: $e');
      return false;
    }
  }

  Future<AttachmentInfo?> uploadFile({required AttachmentFile file, required int key}) async {
    if(!file.uploadFile) return null;
    final presingedData = await _getPreSignUrl(file: file, key: key);
    if(presingedData == null) return null;
    if(file.id > -1) {
      await deleteFile(file.id);
    }
    bool success = await _uploadFile(file, presingedData.presignedUrl);
    if(!success) return null;
    return presingedData.attachmentInfo;
  }

  AttachmentFile? _convertXFileToAttachmentFile(XFile? xfile, {String attachmentType = ''}) {
    if(xfile == null) return null;
    final String mime = lookupMimeType(xfile.path) ?? 'application/octet-stream';
    final String fileName = _getRandomFileName(xfile.name);
    final AttachmentFile file = AttachmentFile(id: -1, url: xfile.path, name: fileName, mime: mime, type: attachmentType, uploadFile: true);
    return file;
  }

  Future<bool> _checkFileSize(AttachmentFile file) async {
    final fileData = File(file.url);
    final fileSize = await fileData.length();
    if(fileSize > limitSize) {
      return false;
    }
    return true;
  }

  Future<AttachmentFile?> pickGallery(String attachmentType) async {
    final ImagePicker picker = ImagePicker();
    final AttachmentFile? file = _convertXFileToAttachmentFile(await picker.pickImage(source: ImageSource.gallery), attachmentType: attachmentType);
    if(file == null) return file;
    if(await _checkFileSize(file) ==  false) {
      //TODO : 100MB 파일 오버될 경우 띄우기 필요.
      return null;
    }
    return file;
  }

  Future<AttachmentFile?> pickCamera(String attachmentType) async {
    final ImagePicker picker = ImagePicker();
    final AttachmentFile? file = _convertXFileToAttachmentFile(await picker.pickImage(source: ImageSource.camera), attachmentType: attachmentType);
    if(file == null) return file;
    if(await _checkFileSize(file) ==  false) {
      //TODO : 100MB 파일 오버될 경우 띄우기 필요.
      return null;
    }
    return file;
  }

  Future<AttachmentFile?> pickVideo(String attachmentType) async {
    final ImagePicker picker = ImagePicker();
    final file = _convertXFileToAttachmentFile(await picker.pickVideo(source: ImageSource.gallery), attachmentType: attachmentType);
    if(file == null) return file;
    if(await _checkFileSize(file) ==  false) {
      //TODO : 100MB 파일 오버될 경우 띄우기 필요.
      return null;
    }
    return file;
  }

  Future<bool> deleteFile(int atIdx) async {
    final response = await FileApiService().deleteFile(atIdx);
    return response;
  }

  Future<bool> saveGallery(String url, String fileName) async {
    final response = await FileApiService().getFileData(url);
    final result = await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.data), quality: 60, name: fileName);
    return result['isSuccess'] == true;
  }

  Future<bool> saveFile(String imgUrl, String fileName) async {
    String dir = (await getApplicationDocumentsDirectory()).path; //path provider로 저장할 경로 가져오기
    // String dirPhoto = (await ()).path;
    try {
      await FlutterDownloader.enqueue(
        url: imgUrl, // file url
        savedDir: '$dir/', // 저장할 dir
        fileName: fileName, // 파일명
        saveInPublicStorage: true, // 동일한 파일 있을 경우 덮어쓰기 없으면 오류발생함!
      );
      // showDefaultToast(localization.automatic667);
      return true;
    } catch (e) {
      // showDefaultToast(localization.automatic874);
      print("error :::: $e");
      return false;
    }
  }
}