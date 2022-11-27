abstract class PermissionsCheckEvent {
  const PermissionsCheckEvent();
}

class PermissionsDeniedEvent extends PermissionsCheckEvent {
  const PermissionsDeniedEvent();
}

class PermissionsGrantedEvent extends PermissionsCheckEvent {
  const PermissionsGrantedEvent();
}
