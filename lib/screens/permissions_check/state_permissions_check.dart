abstract class PermissionsCheckState {
  const PermissionsCheckState();
}

class LoadingState extends PermissionsCheckState {
  const LoadingState();
}

class PermissionsGrantedState extends PermissionsCheckState {
  const PermissionsGrantedState();
}

class PermissionsDeniedState extends PermissionsCheckState {
  const PermissionsDeniedState();
}
