import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/ui/screen/news/models/news_state.dart';

part 'news_view_model.g.dart';



@riverpod
class NewsViewModel extends _$NewsViewModel {

  @override
  FutureOr<NewsState> build() async {
    // _magazineService = ref.read(magazineServiceProvider.notifier);
    // return await _fetchMagazine(DateTime.now());
    return NewsState();
  }


  // Future<MagazineState> _fetchMagazine(DateTime date) async {
  //   final ResponseModel<News> response = await _magazineService.getMagazine(date);
  //   return MagazineState(magazine: response.result);
  // }

}
