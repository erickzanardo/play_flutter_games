import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:play_flutter_games_hub/adapters/adapters.dart';
import 'package:play_flutter_games_hub/app/app.dart';
import 'package:play_flutter_games_hub/bootstrap.dart';
import 'package:play_flutter_games_hub/token_provider_storage/token_provider_storage.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  final tokenProviderStorage = TokenProviderStorage();
  final tokenProvider = TokenProvider(
    getToken: tokenProviderStorage.getToken,
    storeToken: tokenProviderStorage.storeToken,
    clearToken: tokenProviderStorage.clearToken,
  );
  final apiClient = ApiClient(
    baseUrl: 'https://api.example.com',
    tokenProvider: tokenProvider,
  );

  bootstrap(
    () => App(
      authenticationRepository: AuthenticationRepository(
        apiClient: apiClient,
      ),
      postRepository: PostRepository(
        adapter: HubPostRepositoryAdapter(
          apiClient: apiClient,
        ),
      ),
      userRepository: UserRepository(
        apiClient: apiClient,
      ),
      tokenProvider: tokenProvider,
    ),
  );
}
