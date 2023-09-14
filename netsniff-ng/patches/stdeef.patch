diff -Naupr a/trafgen/Makefile b/trafgen/Makefile
--- a/trafgen/Makefile	2021-01-11 12:51:50.000000000 +0100
+++ b/trafgen/Makefile	2023-09-14 14:06:31.785155849 +0200
@@ -53,8 +53,5 @@ endif
 
 trafgen-confs =	trafgen_stddef.h
 
-trafgen_post_install:
-	$(Q)mv $(DESTDIR)$(ETCDIRE)/trafgen_stddef.h $(DESTDIR)$(ETCDIRE)/stddef.h
-
 trafgen_clean_custom:
 	$(Q)$(call RM,$(BUILD_DIR)/*.h $(BUILD_DIR)/*.c)
