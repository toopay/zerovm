#RELEASE BUILD
#CCFLAGS=-DNDEBUG -O2
#CXXFLAGS=-DNDEBUG -O2

#DEBUG BUILD
CCFLAGS=-DDEBUG -g
CXXFLAGS=-DDEBUG -g

CCFLAGS0=-c -m64 -D_FORTIFY_SOURCE=2 -DNACL_WINDOWS=0 -DNACL_OSX=0 -DNACL_LINUX=1 -D_BSD_SOURCE=1 -D_POSIX_C_SOURCE=199506 -D_XOPEN_SOURCE=600 -D_GNU_SOURCE=1 -D_LARGEFILE64_SOURCE=1 -D__STDC_LIMIT_MACROS=1 -D__STDC_FORMAT_MACROS=1 -DNACL_BLOCK_SHIFT=5 -DNACL_BLOCK_SIZE=32 -DNACL_BUILD_ARCH=x86 -DNACL_BUILD_SUBARCH=64 -DNACL_TARGET_ARCH=x86 -DNACL_TARGET_SUBARCH=64 -DNACL_STANDALONE=1 -DNACL_ENABLE_TMPFS_REDIRECT_VAR=0 -I.
CCFLAGS1=-std=gnu99 -Wdeclaration-after-statement -fPIE -Wall -pedantic -Wno-long-long -fvisibility=hidden -fstack-protector --param ssp-buffer-size=4
CCFLAGS2=-Wextra -Wswitch-enum -Wsign-compare
CCFLAGS3=-fno-strict-aliasing -Wno-missing-field-initializers
CCFLAGS4=-DNACL_TRUSTED_BUT_NOT_TCB
CXXFLAGS1=-c -std=c++98 -Wno-variadic-macros -m64 -fPIE -Wall -pedantic -Wno-long-long -fvisibility=hidden -fstack-protector --param ssp-buffer-size=4 -DNACL_TRUSTED_BUT_NOT_TCB -D_FORTIFY_SOURCE=2 -DNACL_WINDOWS=0 -DNACL_OSX=0 -DNACL_LINUX=1 -D_BSD_SOURCE=1 -D_POSIX_C_SOURCE=199506 -D_XOPEN_SOURCE=600 -D_GNU_SOURCE=1 -D_LARGEFILE64_SOURCE=1 -D__STDC_LIMIT_MACROS=1 -D__STDC_FORMAT_MACROS=1 -DNACL_BLOCK_SHIFT=5 -DNACL_BLOCK_SIZE=32 -DNACL_BUILD_ARCH=x86 -DNACL_BUILD_SUBARCH=64 -DNACL_TARGET_ARCH=x86 -DNACL_TARGET_SUBARCH=64 -DNACL_STANDALONE=1 -DNACL_ENABLE_TMPFS_REDIRECT_VAR=0 -I.
CXXFLAGS2=-Wl,-z,noexecstack -m64 -Wno-variadic-macros -L/usr/lib64 -pie -Wl,-z,relro -Wl,-z,now -Wl,-rpath=obj

all: create_dirs zerovm tests

create_dirs: 
	@mkdir obj -p
	@mkdir test -p

zerovm: obj/sel_main.o obj/libsel.a obj/libnacl_error_code.a obj/libgio_wrapped_desc.a obj/libnrd_xfer.a obj/libnacl_perf_counter.a obj/libnacl_base.a obj/libimc.a obj/libnacl_fault_inject.a obj/libplatform.a obj/libplatform_qual_lib.a obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o zerovm ${CXXFLAGS2} obj/sel_main.o -L/usr/lib -lsel -lnacl_error_code -lgio_wrapped_desc -lnrd_xfer -lnacl_perf_counter -lnacl_base -limc -lnacl_fault_inject -lplatform -lplatform_qual_lib -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -ldl -Lobj -Lgtest

tests: test_compile
	test/x86_validator_tests_nc_remaining_memory
	test/service_runtime_tests
	test/x86_decoder_tests_nc_inst_state
	test/x86_validator_tests_halt_trim
	test/x86_validator_tests_nc_inst_bytes
	test/manifest_parser_test
	test/manifest_setup_test
	test/nacl_log_test

test_compile: test/x86_validator_tests_halt_trim test/service_runtime_tests test/x86_decoder_tests_nc_inst_state test/x86_validator_tests_nc_inst_bytes test/x86_validator_tests_nc_remaining_memory test/manifest_parser_test test/manifest_setup_test test/nacl_log_test

obj/halt_trim_tests.o: src/validator/x86/halt_trim_tests.cc
	@g++ ${CXXFLAGS} -o obj/halt_trim_tests.o ${CXXFLAGS1} -Igtest/include src/validator/x86/halt_trim_tests.cc

test/x86_validator_tests_halt_trim: obj/halt_trim_tests.o obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/x86_validator_tests_halt_trim ${CXXFLAGS2} obj/halt_trim_tests.o -L/usr/lib -Lobj -Lgtest -lgtest -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto

obj/manifest_parser_test.o: src/manifest/manifest_parser_test.cc
	@g++ ${CXXFLAGS} -o obj/manifest_parser_test.o ${CXXFLAGS1} src/manifest/manifest_parser_test.cc
test/manifest_parser_test: obj/manifest_parser_test.o obj/libsel.a obj/libgio_wrapped_desc.a obj/libnrd_xfer.a obj/libnacl_perf_counter.a obj/libnacl_base.a obj/libimc.a obj/libnacl_fault_inject.a obj/libplatform.a obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/manifest_parser_test ${CXXFLAGS2} obj/manifest_parser_test.o -L/usr/lib -Lobj -Lgtest -lgtest -lsel -lgio_wrapped_desc -lnrd_xfer -lnacl_perf_counter -lnacl_base -limc -lnacl_fault_inject -lplatform -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -ldl

obj/manifest_setup_test.o: src/manifest/manifest_setup_test.cc
	@g++ ${CXXFLAGS} -o obj/manifest_setup_test.o ${CXXFLAGS1} src/manifest/manifest_setup_test.cc
test/manifest_setup_test: obj/manifest_setup_test.o obj/libsel.a obj/libgio_wrapped_desc.a obj/libnrd_xfer.a obj/libnacl_perf_counter.a obj/libnacl_base.a obj/libimc.a obj/libnacl_fault_inject.a obj/libplatform.a obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/manifest_setup_test ${CXXFLAGS2} obj/manifest_setup_test.o -L/usr/lib -Lobj -Lgtest -lgtest -lsel -lgio_wrapped_desc -lnrd_xfer -lnacl_perf_counter -lnacl_base -limc -lnacl_fault_inject -lplatform -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -ldl

obj/nacl_log_test.o: src/platform/nacl_log_test.cc
	@g++ ${CXXFLAGS} -o obj/nacl_log_test.o ${CXXFLAGS1} src/platform/nacl_log_test.cc
test/nacl_log_test: obj/nacl_log_test.o obj/libsel.a obj/libgio_wrapped_desc.a obj/libnrd_xfer.a obj/libnacl_perf_counter.a obj/libnacl_base.a obj/libimc.a obj/libnacl_fault_inject.a obj/libplatform.a obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/nacl_log_test ${CXXFLAGS2} obj/nacl_log_test.o -L/usr/lib -Lobj -Lgtest -lgtest -lsel -lgio_wrapped_desc -lnrd_xfer -lnacl_perf_counter -lnacl_base -limc -lnacl_fault_inject -lplatform -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -ldl


obj/sel_ldr_test.o: src/service_runtime/sel_ldr_test.cc
	@g++ ${CXXFLAGS} -o obj/sel_ldr_test.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} -Igtest/include src/service_runtime/sel_ldr_test.cc

obj/sel_mem_test.o: src/service_runtime/sel_mem_test.cc
	@g++ ${CXXFLAGS} -o obj/sel_mem_test.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} -Igtest/include src/service_runtime/sel_mem_test.cc

obj/sel_memory_unittest.o: src/service_runtime/sel_memory_unittest.cc
	@g++ ${CXXFLAGS} -o obj/sel_memory_unittest.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} -Igtest/include src/service_runtime/sel_memory_unittest.cc

obj/unittest_main.o: src/service_runtime/unittest_main.cc
	@g++ ${CXXFLAGS} -o obj/unittest_main.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} -Igtest/include src/service_runtime/unittest_main.cc

test/service_runtime_tests: obj/sel_ldr_test.o obj/sel_mem_test.o obj/sel_memory_unittest.o obj/unittest_main.o obj/libsel.a obj/libgio_wrapped_desc.a obj/libnrd_xfer.a obj/libnacl_perf_counter.a obj/libnacl_base.a obj/libimc.a obj/libnacl_fault_inject.a obj/libplatform.a obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/service_runtime_tests ${CXXFLAGS2} obj/unittest_main.o obj/sel_memory_unittest.o obj/sel_mem_test.o obj/sel_ldr_test.o -L/usr/lib -lgtest -lsel -lgio_wrapped_desc -lnrd_xfer -lnacl_perf_counter -lnacl_base -limc -lnacl_fault_inject -lplatform -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -ldl -Lobj -Lgtest

obj/nc_inst_state_tests.o: src/validator/x86/decoder/nc_inst_state_tests.cc
	@g++ ${CXXFLAGS} -o obj/nc_inst_state_tests.o ${CXXFLAGS1} -Igtest/include src/validator/x86/decoder/nc_inst_state_tests.cc

test/x86_decoder_tests_nc_inst_state: obj/nc_inst_state_tests.o obj/ncval_decode_tables.o obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/x86_decoder_tests_nc_inst_state ${CXXFLAGS2} obj/nc_inst_state_tests.o obj/ncval_decode_tables.o -L/usr/lib -lgtest -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -Lobj -Lgtest

obj/nc_inst_bytes_tests.o: src/validator/x86/nc_inst_bytes_tests.cc
	@g++ ${CXXFLAGS} -o obj/nc_inst_bytes_tests.o ${CXXFLAGS1} -Igtest/include src/validator/x86/nc_inst_bytes_tests.cc

test/x86_validator_tests_nc_inst_bytes: obj/nc_inst_bytes_tests.o obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/x86_validator_tests_nc_inst_bytes ${CXXFLAGS2} obj/nc_inst_bytes_tests.o -L/usr/lib -lgtest -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -Lobj -Lgtest

obj/nc_remaining_memory_tests.o: src/validator/x86/nc_remaining_memory_tests.cc
	@g++ ${CXXFLAGS} -o obj/nc_remaining_memory_tests.o ${CXXFLAGS1} -Igtest/include src/validator/x86/nc_remaining_memory_tests.cc

test/x86_validator_tests_nc_remaining_memory: obj/nc_remaining_memory_tests.o obj/libncvalidate_x86_64.a obj/libncval_reg_sfi_x86_64.a obj/libnccopy_x86_64.a obj/libnc_decoder_x86_64.a obj/libnc_opcode_modeling_x86_64.a obj/libncval_base_x86_64.a obj/libplatform.a obj/libgio.a
	@g++ ${CXXFLAGS} -o test/x86_validator_tests_nc_remaining_memory ${CXXFLAGS2} obj/nc_remaining_memory_tests.o -L/usr/lib -lgtest -lncvalidate_x86_64 -lncval_reg_sfi_x86_64 -lnccopy_x86_64 -lnc_decoder_x86_64 -lnc_opcode_modeling_x86_64 -lncval_base_x86_64 -lplatform -lgio -lrt -lpthread -lcrypto -Lobj -Lgtest

clean: clean_intermediate
	@rm zerovm
	@echo ZeroVM has been deleted

clean_intermediate:
	@rm obj/*
	@echo intermediate files has been deleted
	@rm test/*
	@echo unit tests has been deleted

#obj/libmanifest.a: obj/manifest_parser.o obj/manifest_setup.o obj/md5.o obj/mount_channel.o obj/prefetch.o obj/preload.o obj/premap.o obj/trap.o
#	@ar rc obj/libmanifest.a obj/manifest_parser.o obj/manifest_setup.o obj/md5.o obj/mount_channel.o obj/prefetch.o obj/preload.o obj/premap.o obj/trap.o

obj/libsel.a: obj/dyn_array.o obj/elf_util.o obj/nacl_all_modules.o obj/nacl_desc_effector_ldr.o obj/nacl_globals.o obj/nacl_memory_object.o obj/nacl_signal_common.o obj/nacl_syscall_handlers.o obj/nacl_syscall_hook.o obj/nacl_text.o obj/sel_addrspace.o obj/sel_ldr.o obj/sel_ldr_standard.o obj/sel_mem.o obj/sel_qualify.o obj/sel_util-inl.o obj/sel_validate_image.o obj/nacl_ldt_x86.o obj/nacl_switch_64.o obj/nacl_switch_to_app_64.o obj/nacl_syscall_64.o obj/sel_addrspace_x86_64.o obj/sel_ldr_x86_64.o obj/sel_rt_64.o obj/tramp_64.o obj/sel_addrspace_posix_x86_64.o obj/sel_memory.o obj/nacl_ldt.o obj/sel_segments.o obj/nacl_signal.o obj/nacl_signal_64.o obj/manifest_parser.o obj/manifest_setup.o obj/md5.o obj/mount_channel.o obj/prefetch.o obj/preload.o obj/premap.o obj/trap.o
	@ar rc obj/libsel.a obj/dyn_array.o obj/elf_util.o obj/nacl_all_modules.o obj/nacl_desc_effector_ldr.o obj/nacl_globals.o obj/nacl_memory_object.o obj/nacl_signal_common.o obj/nacl_syscall_handlers.o obj/nacl_syscall_hook.o obj/nacl_text.o obj/sel_addrspace.o obj/sel_ldr.o obj/sel_ldr_standard.o obj/sel_mem.o obj/sel_qualify.o obj/sel_util-inl.o obj/sel_validate_image.o obj/nacl_ldt_x86.o obj/nacl_switch_64.o obj/nacl_switch_to_app_64.o obj/nacl_syscall_64.o obj/sel_addrspace_x86_64.o obj/sel_ldr_x86_64.o obj/sel_rt_64.o obj/tramp_64.o obj/sel_addrspace_posix_x86_64.o obj/sel_memory.o obj/nacl_ldt.o obj/sel_segments.o obj/nacl_signal.o obj/nacl_signal_64.o obj/manifest_parser.o obj/manifest_setup.o obj/md5.o obj/mount_channel.o obj/prefetch.o obj/preload.o obj/premap.o obj/trap.o

obj/libnacl_error_code.a: obj/nacl_error_code.o
	@ar rc obj/libnacl_error_code.a obj/nacl_error_code.o

obj/libgio_wrapped_desc.a: obj/gio_shm.o obj/gio_shm_unbounded.o obj/gio_nacl_desc.o
	@ar rc obj/libgio_wrapped_desc.a obj/gio_shm.o obj/gio_shm_unbounded.o obj/gio_nacl_desc.o

obj/libnrd_xfer.a: obj/nacl_desc_base.o obj/nacl_desc_cond.o obj/nacl_desc_dir.o obj/nacl_desc_effector_trusted_mem.o obj/nacl_desc_imc.o obj/nacl_desc_imc_shm.o obj/nacl_desc_invalid.o obj/nacl_desc_io.o obj/nacl_desc_mutex.o obj/nacl_desc_rng.o obj/nacl_desc_semaphore.o obj/nacl_desc_sync_socket.o obj/nrd_all_modules.o obj/nacl_desc.o obj/nacl_desc_sysv_shm.o obj/nacl_desc_conn_cap.o obj/nacl_desc_imc_bound_desc.o
	@ar rc obj/libnrd_xfer.a obj/nacl_desc_base.o obj/nacl_desc_cond.o obj/nacl_desc_dir.o obj/nacl_desc_effector_trusted_mem.o obj/nacl_desc_imc.o obj/nacl_desc_imc_shm.o obj/nacl_desc_invalid.o obj/nacl_desc_io.o obj/nacl_desc_mutex.o obj/nacl_desc_rng.o obj/nacl_desc_semaphore.o obj/nacl_desc_sync_socket.o obj/nrd_all_modules.o obj/nacl_desc.o obj/nacl_desc_sysv_shm.o obj/nacl_desc_conn_cap.o obj/nacl_desc_imc_bound_desc.o

obj/libnacl_perf_counter.a: obj/nacl_perf_counter.o
	@ar rc obj/libnacl_perf_counter.a obj/nacl_perf_counter.o

obj/libnacl_base.a: obj/nacl_refcount.o
	@ar rc obj/libnacl_base.a obj/nacl_refcount.o

obj/libimc.a: obj/nacl_imc_common.o obj/nacl_imc_c.o obj/nacl_imc_unistd.o obj/nacl_imc.o
	@ar rc obj/libimc.a obj/nacl_imc_common.o obj/nacl_imc_c.o obj/nacl_imc_unistd.o obj/nacl_imc.o

obj/libnacl_fault_inject.a: obj/fault_injection.o
	@ar rc obj/libnacl_fault_inject.a obj/fault_injection.o

obj/libplatform.a: obj/nacl_exit.o obj/nacl_find_addrsp.o obj/nacl_host_desc.o obj/nacl_host_dir.o obj/nacl_secure_random.o obj/nacl_semaphore.o obj/nacl_time.o obj/nacl_timestamp.o obj/condition_variable.o obj/lock.o obj/nacl_check.o obj/nacl_global_secure_random.o obj/nacl_host_desc_common.o obj/nacl_interruptible_condvar.o obj/nacl_interruptible_mutex.o obj/nacl_log.o obj/nacl_secure_random_common.o obj/nacl_sync_checked.o obj/platform_init.o
	@ar rc obj/libplatform.a obj/nacl_exit.o obj/nacl_find_addrsp.o obj/nacl_host_desc.o obj/nacl_host_dir.o obj/nacl_secure_random.o obj/nacl_semaphore.o obj/nacl_time.o obj/nacl_timestamp.o obj/condition_variable.o obj/lock.o obj/nacl_check.o obj/nacl_global_secure_random.o obj/nacl_host_desc_common.o obj/nacl_interruptible_condvar.o obj/nacl_interruptible_mutex.o obj/nacl_log.o obj/nacl_secure_random_common.o obj/nacl_sync_checked.o obj/platform_init.o

obj/libplatform_qual_lib.a: obj/nacl_os_qualify.o obj/sysv_shm_and_mmap.o obj/nacl_dep_qualify.o obj/nacl_dep_qualify_arch.o
	@ar rc obj/libplatform_qual_lib.a obj/nacl_os_qualify.o obj/sysv_shm_and_mmap.o obj/nacl_dep_qualify.o obj/nacl_dep_qualify_arch.o

obj/libncvalidate_x86_64.a: obj/ncvalidate.o
	@ar rc obj/libncvalidate_x86_64.a obj/ncvalidate.o

obj/libncval_reg_sfi_x86_64.a: obj/ncvalidate_iter.o obj/ncvalidate_iter_detailed.o obj/ncvalidator_registry.o obj/ncvalidator_registry_detailed.o obj/nc_cpu_checks.o obj/nc_illegal.o obj/nc_jumps.o obj/address_sets.o obj/nc_jumps_detailed.o obj/nc_opcode_histogram.o obj/nc_protect_base.o obj/nc_memory_protect.o obj/ncvalidate_utils.o obj/ncval_decode_tables.o
	@ar rc obj/libncval_reg_sfi_x86_64.a obj/ncvalidate_iter.o obj/ncvalidate_iter_detailed.o obj/ncvalidator_registry.o obj/ncvalidator_registry_detailed.o obj/nc_cpu_checks.o obj/nc_illegal.o obj/nc_jumps.o obj/address_sets.o obj/nc_jumps_detailed.o obj/nc_opcode_histogram.o obj/nc_protect_base.o obj/nc_memory_protect.o obj/ncvalidate_utils.o obj/ncval_decode_tables.o

obj/libnccopy_x86_64.a: obj/nccopycode.o obj/nccopycode_stores.o
	@ar rc obj/libnccopy_x86_64.a obj/nccopycode.o obj/nccopycode_stores.o

obj/libnc_decoder_x86_64.a: obj/nc_inst_iter.o obj/nc_inst_state.o obj/nc_inst_trans.o obj/ncop_exps.o
	@ar rc obj/libnc_decoder_x86_64.a obj/nc_inst_iter.o obj/nc_inst_state.o obj/nc_inst_trans.o obj/ncop_exps.o

obj/libnc_opcode_modeling_x86_64.a: obj/ncopcode_desc.o
	@ar rc obj/libnc_opcode_modeling_x86_64.a obj/ncopcode_desc.o

obj/libncval_base_x86_64.a: obj/error_reporter.o obj/halt_trim.o obj/nacl_cpuid.o obj/nacl_xgetbv.o obj/ncinstbuffer.o obj/x86_insts.o obj/nc_segment.o
	@ar rc obj/libncval_base_x86_64.a obj/error_reporter.o obj/halt_trim.o obj/nacl_cpuid.o obj/nacl_xgetbv.o obj/ncinstbuffer.o obj/x86_insts.o obj/nc_segment.o

obj/libgio.a: obj/gio.o obj/gio_mem.o obj/gprintf.o obj/gio_mem_snapshot.o
	@ar rc obj/libgio.a obj/gio.o obj/gio_mem.o obj/gprintf.o obj/gio_mem_snapshot.o

######################################################################## compilation to obj
obj/mount_channel.o: src/manifest/mount_channel.c
	@gcc ${CCFLAGS} -o obj/mount_channel.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/mount_channel.c

obj/prefetch.o: src/manifest/prefetch.c
	@gcc ${CCFLAGS} -o obj/prefetch.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/prefetch.c

obj/preload.o: src/manifest/preload.c
	@gcc ${CCFLAGS} -o obj/preload.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/preload.c

obj/premap.o: src/manifest/premap.c
	@gcc ${CCFLAGS} -o obj/premap.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/premap.c

obj/trap.o: src/manifest/trap.c
	@gcc ${CCFLAGS} -o obj/trap.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/trap.c

obj/manifest_setup.o: src/manifest/manifest_setup.c
	@gcc ${CCFLAGS} -o obj/manifest_setup.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/manifest_setup.c

obj/md5.o: src/manifest/md5.c
	@gcc ${CCFLAGS} -o obj/md5.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/manifest/md5.c

obj/manifest_parser.o: src/manifest/manifest_parser.c
	@gcc ${CCFLAGS} -o obj/manifest_parser.o ${CCFLAGS0} ${CCFLAGS1} src/manifest/manifest_parser.c

obj/ncvalidate.o: src/validator/x86/64/ncvalidate.c
	@gcc ${CCFLAGS} -o obj/ncvalidate.o ${CCFLAGS0} ${CCFLAGS1} ${CCFLAGS4} src/validator/x86/64/ncvalidate.c

obj/nacl_switch_64.o: src/service_runtime/arch/x86_64/nacl_switch_64.S
	@gcc ${CCFLAGS} -o obj/nacl_switch_64.o ${CCFLAGS0} ${CCFLAGS2} src/service_runtime/arch/x86_64/nacl_switch_64.S

obj/nacl_syscall_64.o: src/service_runtime/arch/x86_64/nacl_syscall_64.S
	@gcc ${CCFLAGS} -o obj/nacl_syscall_64.o ${CCFLAGS0} ${CCFLAGS2} src/service_runtime/arch/x86_64/nacl_syscall_64.S

obj/tramp_64.o: src/service_runtime/arch/x86_64/tramp_64.S
	@gcc ${CCFLAGS} -o obj/tramp_64.o ${CCFLAGS0} ${CCFLAGS2} src/service_runtime/arch/x86_64/tramp_64.S

obj/nccopycode_stores.o: src/validator_x86/nccopycode_stores.S
	@gcc ${CCFLAGS} -o obj/nccopycode_stores.o ${CCFLAGS0} ${CCFLAGS2} src/validator_x86/nccopycode_stores.S

obj/nacl_xgetbv.o: src/validator/x86/nacl_xgetbv.S
	@gcc ${CCFLAGS} -o obj/nacl_xgetbv.o ${CCFLAGS0} ${CCFLAGS2} src/validator/x86/nacl_xgetbv.S

obj/sel_main.o: src/service_runtime/sel_main.c
	@gcc ${CCFLAGS} -o obj/sel_main.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_main.c

obj/dyn_array.o: src/service_runtime/dyn_array.c
	@gcc ${CCFLAGS} -o obj/dyn_array.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/dyn_array.c

obj/elf_util.o: src/service_runtime/elf_util.c
	@gcc ${CCFLAGS} -o obj/elf_util.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/elf_util.c

obj/nacl_all_modules.o: src/service_runtime/nacl_all_modules.c
	@gcc ${CCFLAGS} -o obj/nacl_all_modules.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_all_modules.c

obj/nacl_desc_effector_ldr.o: src/service_runtime/nacl_desc_effector_ldr.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_effector_ldr.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_desc_effector_ldr.c

obj/nacl_globals.o: src/service_runtime/nacl_globals.c
	@gcc ${CCFLAGS} -o obj/nacl_globals.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_globals.c

obj/nacl_memory_object.o: src/service_runtime/nacl_memory_object.c
	@gcc ${CCFLAGS} -o obj/nacl_memory_object.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_memory_object.c

obj/nacl_signal_common.o: src/service_runtime/nacl_signal_common.c
	@gcc ${CCFLAGS} -o obj/nacl_signal_common.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_signal_common.c

obj/nacl_syscall_handlers.o: src/service_runtime/nacl_syscall_handlers.c
	@gcc ${CCFLAGS} -o obj/nacl_syscall_handlers.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_syscall_handlers.c

obj/nacl_syscall_hook.o: src/service_runtime/nacl_syscall_hook.c
	@gcc ${CCFLAGS} -o obj/nacl_syscall_hook.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_syscall_hook.c

obj/nacl_text.o: src/service_runtime/nacl_text.c
	@gcc ${CCFLAGS} -o obj/nacl_text.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_text.c

obj/sel_addrspace.o: src/service_runtime/sel_addrspace.c
	@gcc ${CCFLAGS} -o obj/sel_addrspace.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_addrspace.c

obj/sel_ldr.o: src/service_runtime/sel_ldr.c
	@gcc ${CCFLAGS} -o obj/sel_ldr.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_ldr.c

obj/sel_ldr_standard.o: src/service_runtime/sel_ldr_standard.c
	@gcc ${CCFLAGS} -o obj/sel_ldr_standard.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_ldr_standard.c

obj/sel_mem.o: src/service_runtime/sel_mem.c
	@gcc ${CCFLAGS} -o obj/sel_mem.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_mem.c

obj/sel_qualify.o: src/service_runtime/sel_qualify.c
	@gcc ${CCFLAGS} -o obj/sel_qualify.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_qualify.c

obj/sel_util-inl.o: src/service_runtime/sel_util-inl.c
	@gcc ${CCFLAGS} -o obj/sel_util-inl.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_util-inl.c

obj/sel_validate_image.o: src/service_runtime/sel_validate_image.c
	@gcc ${CCFLAGS} -o obj/sel_validate_image.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/sel_validate_image.c

obj/nacl_ldt_x86.o: src/service_runtime/arch/x86/nacl_ldt_x86.c
	@gcc ${CCFLAGS} -o obj/nacl_ldt_x86.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/arch/x86/nacl_ldt_x86.c

obj/nacl_switch_to_app_64.o: src/service_runtime/arch/x86_64/nacl_switch_to_app_64.c
	@gcc ${CCFLAGS} -o obj/nacl_switch_to_app_64.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/arch/x86_64/nacl_switch_to_app_64.c

obj/sel_addrspace_x86_64.o: src/service_runtime/arch/x86_64/sel_addrspace_x86_64.c
	@gcc ${CCFLAGS} -o obj/sel_addrspace_x86_64.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/arch/x86_64/sel_addrspace_x86_64.c

obj/sel_ldr_x86_64.o: src/service_runtime/arch/x86_64/sel_ldr_x86_64.c
	@gcc ${CCFLAGS} -o obj/sel_ldr_x86_64.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/arch/x86_64/sel_ldr_x86_64.c

obj/sel_rt_64.o: src/service_runtime/arch/x86_64/sel_rt_64.c
	@gcc ${CCFLAGS} -o obj/sel_rt_64.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/arch/x86_64/sel_rt_64.c

obj/sel_addrspace_posix_x86_64.o: src/service_runtime/arch/x86_64/sel_addrspace_posix_x86_64.c
	@gcc ${CCFLAGS} -o obj/sel_addrspace_posix_x86_64.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/arch/x86_64/sel_addrspace_posix_x86_64.c

obj/sel_memory.o: src/service_runtime/linux/sel_memory.c
	@gcc ${CCFLAGS} -o obj/sel_memory.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/linux/sel_memory.c

obj/nacl_ldt.o: src/service_runtime/linux/x86/nacl_ldt.c
	@gcc ${CCFLAGS} -o obj/nacl_ldt.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/linux/x86/nacl_ldt.c

obj/sel_segments.o: src/service_runtime/linux/x86/sel_segments.c
	@gcc ${CCFLAGS} -o obj/sel_segments.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/linux/x86/sel_segments.c

obj/nacl_signal.o: src/service_runtime/posix/nacl_signal.c
	@gcc ${CCFLAGS} -o obj/nacl_signal.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/posix/nacl_signal.c

obj/nacl_signal_64.o: src/service_runtime/linux/nacl_signal_64.c
	@gcc ${CCFLAGS} -o obj/nacl_signal_64.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/linux/nacl_signal_64.c

obj/nacl_error_code.o: src/service_runtime/nacl_error_code.c
	@gcc ${CCFLAGS} -o obj/nacl_error_code.o ${CCFLAGS0} ${CCFLAGS1} src/service_runtime/nacl_error_code.c

obj/gio_shm.o: src/gio/gio_shm.c
	@gcc ${CCFLAGS} -o obj/gio_shm.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gio_shm.c

obj/gio_shm_unbounded.o: src/gio/gio_shm_unbounded.c
	@gcc ${CCFLAGS} -o obj/gio_shm_unbounded.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gio_shm_unbounded.c

obj/gio_nacl_desc.o: src/gio/gio_nacl_desc.c
	@gcc ${CCFLAGS} -o obj/gio_nacl_desc.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gio_nacl_desc.c

obj/nacl_desc_base.o: src/desc/nacl_desc_base.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_base.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_base.c

obj/nacl_desc_cond.o: src/desc/nacl_desc_cond.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_cond.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_cond.c

obj/nacl_desc_dir.o: src/desc/nacl_desc_dir.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_dir.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_dir.c

obj/nacl_desc_effector_trusted_mem.o: src/desc/nacl_desc_effector_trusted_mem.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_effector_trusted_mem.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_effector_trusted_mem.c

obj/nacl_desc_imc.o: src/desc/nacl_desc_imc.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_imc.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_imc.c

obj/nacl_desc_imc_shm.o: src/desc/nacl_desc_imc_shm.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_imc_shm.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_imc_shm.c

obj/nacl_desc_invalid.o: src/desc/nacl_desc_invalid.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_invalid.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_invalid.c

obj/nacl_desc_io.o: src/desc/nacl_desc_io.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_io.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_io.c

obj/nacl_desc_mutex.o: src/desc/nacl_desc_mutex.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_mutex.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_mutex.c

obj/nacl_desc_rng.o: src/desc/nacl_desc_rng.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_rng.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_rng.c

obj/nacl_desc_semaphore.o: src/desc/nacl_desc_semaphore.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_semaphore.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_semaphore.c

obj/nacl_desc_sync_socket.o: src/desc/nacl_desc_sync_socket.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_sync_socket.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nacl_desc_sync_socket.c

obj/nrd_all_modules.o: src/desc/nrd_all_modules.c
	@gcc ${CCFLAGS} -o obj/nrd_all_modules.o ${CCFLAGS0} ${CCFLAGS1} src/desc/nrd_all_modules.c

obj/nacl_desc.o: src/desc/linux/nacl_desc.c
	@gcc ${CCFLAGS} -o obj/nacl_desc.o ${CCFLAGS0} ${CCFLAGS1} src/desc/linux/nacl_desc.c

obj/nacl_desc_sysv_shm.o:
	@gcc ${CCFLAGS} -o obj/nacl_desc_sysv_shm.o ${CCFLAGS0} ${CCFLAGS1} src/desc/linux/nacl_desc_sysv_shm.c

obj/nacl_desc_conn_cap.o: src/desc/linux/nacl_desc_sysv_shm.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_conn_cap.o ${CCFLAGS0} ${CCFLAGS1} src/desc/posix/nacl_desc_conn_cap.c

obj/nacl_desc_imc_bound_desc.o: src/desc/posix/nacl_desc_imc_bound_desc.c
	@gcc ${CCFLAGS} -o obj/nacl_desc_imc_bound_desc.o ${CCFLAGS0} ${CCFLAGS1} src/desc/posix/nacl_desc_imc_bound_desc.c

obj/nacl_perf_counter.o: src/perf_counter/nacl_perf_counter.c
	@gcc ${CCFLAGS} -o obj/nacl_perf_counter.o ${CCFLAGS0} ${CCFLAGS1} src/perf_counter/nacl_perf_counter.c

obj/nacl_refcount.o: src/nacl_base/nacl_refcount.c
	@gcc ${CCFLAGS} -o obj/nacl_refcount.o ${CCFLAGS0} ${CCFLAGS1} src/nacl_base/nacl_refcount.c

obj/fault_injection.o: src/fault_injection/fault_injection.c
	@gcc ${CCFLAGS} -o obj/fault_injection.o ${CCFLAGS0} ${CCFLAGS1} src/fault_injection/fault_injection.c

obj/nacl_os_qualify.o: src/platform_qualify/linux/nacl_os_qualify.c
	@gcc ${CCFLAGS} -o obj/nacl_os_qualify.o ${CCFLAGS0} ${CCFLAGS1} src/platform_qualify/linux/nacl_os_qualify.c

obj/sysv_shm_and_mmap.o: src/platform_qualify/linux/sysv_shm_and_mmap.c
	@gcc ${CCFLAGS} -o obj/sysv_shm_and_mmap.o ${CCFLAGS0} ${CCFLAGS1} src/platform_qualify/linux/sysv_shm_and_mmap.c

obj/nacl_dep_qualify.o: src/platform_qualify/posix/nacl_dep_qualify.c
	@gcc ${CCFLAGS} -o obj/nacl_dep_qualify.o ${CCFLAGS0} ${CCFLAGS1} src/platform_qualify/posix/nacl_dep_qualify.c

obj/nacl_dep_qualify_arch.o: src/platform_qualify/arch/x86_64/nacl_dep_qualify_arch.c
	@gcc ${CCFLAGS} -o obj/nacl_dep_qualify_arch.o ${CCFLAGS0} ${CCFLAGS1} src/platform_qualify/arch/x86_64/nacl_dep_qualify_arch.c

obj/ncvalidate_iter.o: src/validator/x86/ncval_reg_sfi/ncvalidate_iter.c
	@gcc ${CCFLAGS} -o obj/ncvalidate_iter.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/ncvalidate_iter.c

obj/ncvalidate_iter_detailed.o: src/validator/x86/ncval_reg_sfi/ncvalidate_iter_detailed.c
	@gcc ${CCFLAGS} -o obj/ncvalidate_iter_detailed.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/ncvalidate_iter_detailed.c

obj/ncvalidator_registry.o: src/validator/x86/ncval_reg_sfi/ncvalidator_registry.c
	@gcc ${CCFLAGS} -o obj/ncvalidator_registry.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/ncvalidator_registry.c

obj/ncvalidator_registry_detailed.o: src/validator/x86/ncval_reg_sfi/ncvalidator_registry_detailed.c
	@gcc ${CCFLAGS} -o obj/ncvalidator_registry_detailed.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/ncvalidator_registry_detailed.c

obj/nc_cpu_checks.o: src/validator/x86/ncval_reg_sfi/nc_cpu_checks.c
	@gcc ${CCFLAGS} -o obj/nc_cpu_checks.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_cpu_checks.c

obj/nc_illegal.o: src/validator/x86/ncval_reg_sfi/nc_illegal.c
	@gcc ${CCFLAGS} -o obj/nc_illegal.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_illegal.c

obj/nc_jumps.o: src/validator/x86/ncval_reg_sfi/nc_jumps.c
	@gcc ${CCFLAGS} -o obj/nc_jumps.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_jumps.c

obj/address_sets.o: src/validator/x86/ncval_reg_sfi/address_sets.c
	@gcc ${CCFLAGS} -o obj/address_sets.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/address_sets.c

obj/nc_jumps_detailed.o: src/validator/x86/ncval_reg_sfi/nc_jumps_detailed.c
	@gcc ${CCFLAGS} -o obj/nc_jumps_detailed.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_jumps_detailed.c

obj/nc_opcode_histogram.o: src/validator/x86/ncval_reg_sfi/nc_opcode_histogram.c
	@gcc ${CCFLAGS} -o obj/nc_opcode_histogram.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_opcode_histogram.c

obj/nc_protect_base.o: src/validator/x86/ncval_reg_sfi/nc_protect_base.c
	@gcc ${CCFLAGS} -o obj/nc_protect_base.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_protect_base.c

obj/nc_memory_protect.o: src/validator/x86/ncval_reg_sfi/nc_memory_protect.c
	@gcc ${CCFLAGS} -o obj/nc_memory_protect.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/nc_memory_protect.c

obj/ncvalidate_utils.o: src/validator/x86/ncval_reg_sfi/ncvalidate_utils.c
	@gcc ${CCFLAGS} -o obj/ncvalidate_utils.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/ncvalidate_utils.c

obj/ncval_decode_tables.o: src/validator/x86/ncval_reg_sfi/ncval_decode_tables.c
	@gcc ${CCFLAGS} -o obj/ncval_decode_tables.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncval_reg_sfi/ncval_decode_tables.c

obj/nccopycode.o: src/validator_x86/nccopycode.c
	@gcc ${CCFLAGS} -o obj/nccopycode.o ${CCFLAGS0} ${CCFLAGS1} src/validator_x86/nccopycode.c

obj/nc_inst_iter.o: src/validator/x86/decoder/nc_inst_iter.c
	@gcc ${CCFLAGS} -o obj/nc_inst_iter.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/decoder/nc_inst_iter.c

obj/nc_inst_state.o: src/validator/x86/decoder/nc_inst_state.c
	@gcc ${CCFLAGS} -o obj/nc_inst_state.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/decoder/nc_inst_state.c

obj/nc_inst_trans.o: src/validator/x86/decoder/nc_inst_trans.c
	@gcc ${CCFLAGS} -o obj/nc_inst_trans.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/decoder/nc_inst_trans.c

obj/ncop_exps.o: src/validator/x86/decoder/ncop_exps.c
	@gcc ${CCFLAGS} -o obj/ncop_exps.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/decoder/ncop_exps.c

obj/ncopcode_desc.o: src/validator/x86/decoder/ncopcode_desc.c
	@gcc ${CCFLAGS} -o obj/ncopcode_desc.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/decoder/ncopcode_desc.c

obj/error_reporter.o: src/validator/x86/error_reporter.c
	@gcc ${CCFLAGS} -o obj/error_reporter.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/error_reporter.c

obj/halt_trim.o: src/validator/x86/halt_trim.c
	@gcc ${CCFLAGS} -o obj/halt_trim.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/halt_trim.c

obj/nacl_cpuid.o: src/validator/x86/nacl_cpuid.c
	@gcc ${CCFLAGS} -o obj/nacl_cpuid.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/nacl_cpuid.c

obj/ncinstbuffer.o: src/validator/x86/ncinstbuffer.c
	@gcc ${CCFLAGS} -o obj/ncinstbuffer.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/ncinstbuffer.c

obj/x86_insts.o: src/validator/x86/x86_insts.c
	@gcc ${CCFLAGS} -o obj/x86_insts.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/x86_insts.c

obj/nc_segment.o: src/validator/x86/nc_segment.c
	@gcc ${CCFLAGS} -o obj/nc_segment.o ${CCFLAGS0} ${CCFLAGS1} src/validator/x86/nc_segment.c

obj/nacl_exit.o: src/platform/linux/nacl_exit.c
	@gcc ${CCFLAGS} -o obj/nacl_exit.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_exit.c

obj/nacl_find_addrsp.o: src/platform/linux/nacl_find_addrsp.c
	@gcc ${CCFLAGS} -o obj/nacl_find_addrsp.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_find_addrsp.c

obj/nacl_host_desc.o: src/platform/linux/nacl_host_desc.c
	@gcc ${CCFLAGS} -o obj/nacl_host_desc.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_host_desc.c

obj/nacl_host_dir.o: src/platform/linux/nacl_host_dir.c
	@gcc ${CCFLAGS} -o obj/nacl_host_dir.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_host_dir.c

obj/nacl_secure_random.o: src/platform/linux/nacl_secure_random.c
	@gcc ${CCFLAGS} -o obj/nacl_secure_random.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_secure_random.c

obj/nacl_semaphore.o: src/platform/linux/nacl_semaphore.c
	@gcc ${CCFLAGS} -o obj/nacl_semaphore.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_semaphore.c

obj/nacl_time.o: src/platform/linux/nacl_time.c
	@gcc ${CCFLAGS} -o obj/nacl_time.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_time.c

obj/nacl_timestamp.o: src/platform/linux/nacl_timestamp.c
	@gcc ${CCFLAGS} -o obj/nacl_timestamp.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/nacl_timestamp.c

obj/condition_variable.o: src/platform/linux/condition_variable.c
	@gcc ${CCFLAGS} -o obj/condition_variable.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/condition_variable.c

obj/lock.o: src/platform/linux/lock.c
	@gcc ${CCFLAGS} -o obj/lock.o ${CCFLAGS0} ${CCFLAGS1} src/platform/linux/lock.c

obj/nacl_check.o: src/platform/nacl_check.c
	@gcc ${CCFLAGS} -o obj/nacl_check.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_check.c

obj/nacl_global_secure_random.o: src/platform/nacl_global_secure_random.c
	@gcc ${CCFLAGS} -o obj/nacl_global_secure_random.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_global_secure_random.c

obj/nacl_host_desc_common.o: src/platform/nacl_host_desc_common.c
	@gcc ${CCFLAGS} -o obj/nacl_host_desc_common.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_host_desc_common.c

obj/nacl_interruptible_condvar.o: src/platform/nacl_interruptible_condvar.c
	@gcc ${CCFLAGS} -o obj/nacl_interruptible_condvar.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_interruptible_condvar.c

obj/nacl_interruptible_mutex.o: src/platform/nacl_interruptible_mutex.c
	@gcc ${CCFLAGS} -o obj/nacl_interruptible_mutex.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_interruptible_mutex.c

obj/nacl_log.o: src/platform/nacl_log.c
	@gcc ${CCFLAGS} -o obj/nacl_log.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_log.c

obj/nacl_secure_random_common.o: src/platform/nacl_secure_random_common.c
	@gcc ${CCFLAGS} -o obj/nacl_secure_random_common.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_secure_random_common.c

obj/nacl_sync_checked.o: src/platform/nacl_sync_checked.c
	@gcc ${CCFLAGS} -o obj/nacl_sync_checked.o ${CCFLAGS0} ${CCFLAGS1} src/platform/nacl_sync_checked.c

obj/platform_init.o: src/platform/platform_init.c
	@gcc ${CCFLAGS} -o obj/platform_init.o ${CCFLAGS0} ${CCFLAGS1} src/platform/platform_init.c

obj/gio.o: src/gio/gio.c
	@gcc ${CCFLAGS} -o obj/gio.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gio.c

obj/gio_mem.o: src/gio/gio_mem.c
	@gcc ${CCFLAGS} -o obj/gio_mem.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gio_mem.c

obj/gprintf.o: src/gio/gprintf.c
	@gcc ${CCFLAGS} -o obj/gprintf.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gprintf.c

obj/gio_mem_snapshot.o: src/gio/gio_mem_snapshot.c
	@gcc ${CCFLAGS} -o obj/gio_mem_snapshot.o ${CCFLAGS0} ${CCFLAGS1} src/gio/gio_mem_snapshot.c

obj/nacl_imc_common.o: src/imc/nacl_imc_common.cc
	@g++ ${CXXFLAGS} -o obj/nacl_imc_common.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} src/imc/nacl_imc_common.cc

obj/nacl_imc_c.o: src/imc/nacl_imc_c.cc
	@g++ ${CXXFLAGS} -o obj/nacl_imc_c.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} src/imc/nacl_imc_c.cc

obj/nacl_imc_unistd.o: src/imc/nacl_imc_unistd.cc
	@g++ ${CXXFLAGS} -o obj/nacl_imc_unistd.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} src/imc/nacl_imc_unistd.cc

obj/nacl_imc.o: src/imc/linux/nacl_imc.cc
	@g++ ${CXXFLAGS} -o obj/nacl_imc.o ${CXXFLAGS1} ${CCFLAGS2} ${CCFLAGS4} src/imc/linux/nacl_imc.cc

