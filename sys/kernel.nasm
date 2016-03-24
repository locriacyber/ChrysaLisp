%include 'inc/func.inc'
%include 'inc/mail.inc'
%include 'inc/task.inc'
%include 'inc/link.inc'
%include 'inc/gui.inc'
%include 'inc/sdl2.inc'
%include 'inc/load.inc'

;;;;;;;;;;;;;
; kernel task
;;;;;;;;;;;;;

	fn_function sys/kernel, no_debug_enter
		;loader is already initialized when we get here !
		;inputs
		;r0 = argv pointer

		;save argv on stack
		vp_push r0

		;init tasks
		static_call task, init

		;init allocator
		static_call mem, init

		;init linker
		static_call link, init

		;start kernel task
		static_call task, start
		static_bind task, statics, r2
		vp_cpy r0, [r2 + tk_statics_current_tcb]

		;init mailer, r1 = kernel mailbox !
		static_call mail, init

		;process command options
		vp_cpy [r4], r0
		static_call cpu, opts

		;fill in num cpu's with at least mine + 1
		static_call cpu, id
		vp_inc r0
		static_bind task, statics, r1
		vp_cpy r0, [r1 + tk_statics_cpu_total]

		;allocate for kernel routing table
		vp_sub lk_table_size, r4
		vp_cpy_cl 0, [r4 + lk_table_array]
		vp_cpy_cl 0, [r4 + lk_table_array_size]

;;;;;;;;;;;;;;;;;;;;;;;
; main kernel task loop
;;;;;;;;;;;;;;;;;;;;;;;

		;loop till no other tasks running
		loop_start
			;allow all other tasks to run
			static_call task, yield

			;service all kernel mail
			loop_start
				;check if any mail
				static_bind task, statics, r0
				vp_cpy [r0 + tk_statics_current_tcb], r0
				vp_lea [r0 + tk_node_mailbox], r0
				ml_check r0, r1
				breakif r1, ==, 0

				;read waiting mail
				static_call mail, read
				vp_cpy r0, r15

				;switch on kernel call number
				vp_cpy [r15 + (ml_msg_data + kn_data_kernel_function)], r1
				switch
				case r1, ==, kn_call_task_open
				run_here:
					;fill in reply ID, user field is left alone !
					vp_cpy [r15 + (ml_msg_data + kn_data_kernel_reply)], r1
					vp_cpy [r15 + (ml_msg_data + kn_data_kernel_reply + 8)], r2
					vp_cpy r1, [r15 + ml_msg_dest]
					vp_cpy r2, [r15 + (ml_msg_dest + 8)]

					;open single task and return mailbox ID
					vp_lea [r15 + (ml_msg_data + kn_data_task_open_pathname)], r0
					static_call load, bind
					static_call task, start
					static_call cpu, id
					vp_cpy r1, [r15 + (ml_msg_data + kn_data_task_open_reply_mailboxid)]
					vp_cpy r0, [r15 + (ml_msg_data + kn_data_task_open_reply_mailboxid + 8)]
					vp_cpy_cl ml_msg_data + kn_data_task_open_reply_size, [r15 + ml_msg_length]
					vp_cpy r15, r0
					static_call mail, send
					break
				case r1, ==, kn_call_task_child
					;find best cpu to run task
					static_call cpu, id
					vp_cpy r0, r5
					static_bind task, statics, r1
					vp_cpy [r1 + tk_statics_task_count], r1
					static_bind link, statics, r2
					loop_list_forwards r2 + lk_statics_links_list, r2, r3
						if r1, >, [r3 + lk_node_task_count]
							vp_cpy [r3 + lk_node_cpu_id], r0
							vp_cpy [r3 + lk_node_task_count], r1
						endif
					loop_end
					jmpif r0, ==, r5, run_here

					;send to better kernel
					vp_cpy r0, [r15 + (ml_msg_dest + 8)]
					vp_cpy r15, r0
					static_call mail, send
					break
				case r1, ==, kn_call_task_route
					;increase size of network ?
					static_bind task, statics, r0
					vp_cpy [r15 + ml_msg_data + kn_data_link_route_origin], r1
					vp_inc r1
					if r1, >, [r0 + tk_statics_cpu_total]
						vp_cpy r1, [r0 + tk_statics_cpu_total]
					endif

					;new kernel routing table ?
					vp_cpy [r4 + lk_table_array], r0
					vp_cpy [r4 + lk_table_array_size], r1
					vp_cpy [r15 + ml_msg_data + kn_data_link_route_origin], r11
					vp_mul lk_route_size, r11
					vp_lea [r11 + lk_route_size], r2
					static_call mem, grow
					vp_cpy r0, [r4 + lk_table_array]
					vp_cpy r1, [r4 + lk_table_array_size]

					;compare hop counts
					vp_cpy [r15 + ml_msg_data + kn_data_link_route_hops], r2
					vp_cpy [r0 + r11 + lk_route_hops], r3
					switch
					case r3, ==, 0
						;never seen, so better route
						vp_jmp better_route
					case r2, <, r3
					better_route:
						;new hops is less, so better route
						vp_cpy r2, [r0 + r11]

						;fill in via route and remove other routes
						vp_cpy [r15 + ml_msg_data + kn_data_link_route_via], r13
						static_bind link, statics, r14
						loop_list_forwards r14 + lk_statics_links_list, r14, r12
							;new link route table ?
							vp_cpy [r12 + lk_node_table + lk_table_array], r0
							vp_cpy [r12 + lk_node_table + lk_table_array_size], r1
							vp_lea [r11 + lk_route_size], r2
							static_call mem, grow
							vp_cpy r0, [r12 + lk_node_table + lk_table_array]
							vp_cpy r1, [r12 + lk_node_table + lk_table_array_size]

							if [r12 + lk_node_cpu_id], ==, r13
								;via route
								vp_cpy [r15 + ml_msg_data + kn_data_link_route_hops], r2
								vp_cpy r2, [r0 + r11 + lk_route_hops]
							else
								;none via route
								vp_cpy_cl 0, [r0 + r11 + lk_route_hops]
							endif
						loop_end
						break
					case r2, ==, r3
						;new hops is equal, so additional route
						vp_cpy [r15 + ml_msg_data + kn_data_link_route_via], r13
						static_bind link, statics, r14
						loop_list_forwards r14 + lk_statics_links_list, r14, r12
							;new link route table ?
							vp_cpy [r12 + lk_node_table + lk_table_array], r0
							vp_cpy [r12 + lk_node_table + lk_table_array_size], r1
							vp_lea [r11 + lk_route_size], r2
							static_call mem, grow
							vp_cpy r0, [r12 + lk_node_table + lk_table_array]
							vp_cpy r1, [r12 + lk_node_table + lk_table_array_size]

							if [r12 + lk_node_cpu_id], ==, r13
								;via route
								vp_cpy [r15 + ml_msg_data + kn_data_link_route_hops], r2
								vp_cpy r2, [r0 + r11 + lk_route_hops]
							endif
						loop_end
						;drop through to discard message !
					default
						;new hops is greater, so worse route
						vp_jmp drop_msg
					endswitch

					;increment hop count
					vp_cpy [r15 + ml_msg_data + kn_data_link_route_hops], r1
					vp_inc r1
					vp_cpy r1, [r15 + ml_msg_data + kn_data_link_route_hops]

					;get current via, set via to my cpu id
					vp_cpy [r15 + ml_msg_data + kn_data_link_route_via], r14
					static_call cpu, id
					vp_cpy r0, [r15 + ml_msg_data + kn_data_link_route_via]

					;copy and send to all neighbors apart from old via
					static_bind link, statics, r13
					loop_list_forwards r13 + lk_statics_links_list, r13, r12
						vp_cpy [r12 + lk_node_cpu_id], r11
						continueif r11, ==, r14
						static_call mail, alloc
						fn_assert r0, !=, 0
						vp_cpy r0, r5
						vp_cpy r0, r1
						vp_cpy r15, r0
						vp_cpy [r15 + ml_msg_length], r2
						vp_add 7, r2
						vp_and -8, r2
						static_call mem, copy
						vp_cpy r11, [r5 + (ml_msg_dest + 8)]
						vp_cpy r5, r0
						static_call mail, send
					loop_end
				drop_msg:
					vp_cpy r15, r0
					static_call mem, free
					break
				case r1, ==, kn_call_gui_update
					;free update message
					vp_cpy r15, r0
					static_call mem, free

					;create screen window ?
					static_bind gui, statics, r0
					vp_cpy [r0 + gui_statics_window], r1
					if r1, ==, 0
						;init sdl2
						sdl_set_main_ready
						sdl_init SDL_INIT_VIDEO
						ttf_init

						;create window
						vp_lea [rel title], r0
						sdl_create_window r0, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_OPENGL
						static_bind gui, statics, r1
						vp_cpy r0, [r1 + gui_statics_window]

						;create renderer
						sdl_create_renderer r0, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
						static_bind gui, statics, r1
						vp_cpy r0, [r1 + gui_statics_renderer]

						;set blend mode
						sdl_set_render_draw_blend_mode r0, SDL_BLENDMODE_BLEND
					endif

					;update screen
					static_bind gui, statics, r0
					vp_cpy [r0 + gui_statics_screen], r0
					if r0, !=, 0
						;pump sdl events
						sdl_pump_events

						;get mouse state
						static_bind gui, statics, r0
						vp_lea [r0 + gui_statics_x_pos], r1
						vp_lea [r0 + gui_statics_y_pos], r2
						sdl_get_mouse_state r1, r2
						static_bind gui, statics, r1
						vp_add gui_statics_buttons, r1
						vp_cpy r0, [r1]

						;update the screen
						static_bind gui, statics, r0
						vp_cpy [r0 + gui_statics_screen], r0
						static_call gui, draw

						;refresh the window
						static_bind gui, statics, r0
						sdl_render_present [r0 + gui_statics_renderer]
					endif
				default
				endswitch
			loop_end

			;get time
			static_call cpu, time

			;start any tasks ready to restart
			static_bind task, statics, r3
			vp_cpy [r3 + tk_statics_current_tcb], r15
			vp_cpy [r3 + tk_statics_timer_list + lh_list_head], r2
			ln_get_succ r2, r2
			if r2, !=, 0
				loop_list_forwards r3 + tk_statics_timer_list, r2, r1
					vp_cpy [r1 + tk_node_time], r5
					breakif r5, >, r0

					;task ready, remove from timer list and place on ready list
					vp_cpy r1, r5
					ln_remove_node r5, r6
					ln_add_node_before r15, r1, r6
				loop_end
			endif

			;next task if other ready tasks
			vp_cpy [r3 + tk_statics_task_list + lh_list_head], r2
			vp_cpy [r3 + tk_statics_task_list + lh_list_tailpred], r1
			continueif r2, !=, r1

			;exit if no task waiting for timer
			vp_cpy [r3 + tk_statics_timer_list + lh_list_head], r2
			ln_get_succ r2, r1
			breakif r1, ==, 0

			;sleep till next wake time
			vp_xchg r0, r2
			vp_cpy [r0 + tk_node_time], r0
			vp_sub r2, r0
			vp_cpy 1000, r3
			vp_xor r2, r2
			vp_div r3, r2, r0
			if r0, <, 1
				vp_cpy 1, r0
			endif
			sdl_delay r0
		loop_end

		;deinit gui
		static_call gui, deinit

		;free any kernel routing table
		vp_cpy [r4 + lk_table_array], r0
		static_call mem, free
		vp_add lk_table_size, r4

		;deinit allocator
		static_call mem, deinit

		;deinit mailer
		static_call mail, deinit

		;deinit tasks
		static_call task, deinit

		;deinit loader
		static_call load, deinit

		;pop argv and exit !
		vp_add 8, r4
		sys_exit 0

	title:
		db 'Asm Kernel GUI Window', 0

	fn_function_end
