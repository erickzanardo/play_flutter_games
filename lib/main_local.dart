import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/bootstrap.dart';

void main() {
  const apiClient = ApiClient(
    baseUrl: 'http://localhost:8080',
  );
  bootstrap(
    () => App(
      authenticationRepository: AuthenticationRepository(
        apiClient: apiClient,
      ),
    ),
  );
}