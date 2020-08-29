%hook JailMonkey
- (id)pathsToCheck {
    return NULL;
}
- (id)schemesToCheck {
    return NULL;
}
- (BOOL)checkPaths {
    return 0;
}
- (BOOL)checkSchemes {
    return 0;
}
- (BOOL)canViolateSandbox {
    return 0;
}
- (BOOL)isDebugged {
    return 0;
}
- (BOOL)isJailBroken {
    return 0;
}
%end

%hook ANSMetadata
- (BOOL)computeIsJailbroken {
    return 0;
}
- (BOOL)isJailbroken {
    return 0;
}
%end