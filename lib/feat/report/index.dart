import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dartz/dartz.dart';
import 'package:opket/core/config/usecase.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/core/services/api_client.dart';
import 'package:opket/feat/report/domain/models/report.dart';
import 'package:opket/feat/report/services/report_cache_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'data/report_remote_datasource.dart';
part 'domain/usecases/report_app_info.dart';
part 'data/report_repo_impl.dart';
part 'domain/repo/report_repo.dart';
