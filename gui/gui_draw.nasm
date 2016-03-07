%include 'inc/func.inc'
%include 'inc/list.inc'
%include 'inc/gui.inc'
%include 'class/class_view.inc'

	struc draw_view
		draw_view_ctx:			resb gui_ctx_size
		draw_view_root:			resq 1
		draw_view_node:			resq 1
		draw_view_patch_list:	resq 1
	endstruc

	fn_function gui/gui_draw
		;inputs
		;r0 = view object
		;trashes
		;all but r4

		vp_sub draw_view_size, r4
		vp_cpy r0, [r4 + draw_view_root]
		static_bind gui, statics, r1
		vp_cpy [r1 + gui_statics_renderer], r1
		vp_cpy r1, [r4 + draw_view_ctx + gui_ctx_sdl_ctx]
		vp_cpy 0, qword[r4 + draw_view_patch_list]

		;iterate through views back to front
		;setting abs cords
		vp_xor r8, r8
		vp_xor r9, r9
		vp_cpy [r4 + draw_view_root], r1
		loop_start
		down_loop_ctx:
			vp_cpy r1, r0

			;context abs cords
			vp_add [r0 + view_x], r8
			vp_add [r0 + view_y], r9
			vp_cpy r8, [r0 + view_ctx_x]
			vp_cpy r9, [r0 + view_ctx_y]

			;down to child
			lh_get_head r0 + view_list, r1
			vp_sub view_node, r1
		loop_until qword[r1 + view_node + ln_node_succ], ==, 0
		loop_while r0, !=, [r4 + draw_view_root]
			;context abs cords
			vp_sub [r0 + view_x], r8
			vp_sub [r0 + view_y], r9

			;across to sibling
			ln_get_succ r0 + view_node, r1
			vp_sub view_node, r1
			jmpif qword[r1 + view_node + ln_node_succ], !=, 0, down_loop_ctx

			;up to parent
			vp_cpy [r0 + view_parent], r0
		loop_end

		;iterate through views back to front
		;create visible region list
		vp_cpy [r4 + draw_view_root], r1
		loop_start
		down_loop_back_to_front:
			vp_cpy r1, r0

			;save node
			vp_cpy r0, [r4 + draw_view_node]

			;region heap
			static_bind gui, statics, r0
			vp_lea [r0 + gui_statics_rect_heap], r0

			;if opaque view remove from global dirty list
			vp_cpy [r4 + draw_view_node], r1
			vp_cpy [r1 + view_transparent_list], r2
			if r2, ==, 0
				vp_cpy [r1 + view_ctx_x], r8
				vp_cpy [r1 + view_ctx_y], r9
				vp_cpy [r1 + view_w], r10
				vp_cpy [r1 + view_h], r11
				vp_add r8, r10
				vp_add r9, r11
				vp_lea [r4 + draw_view_patch_list], r1
				static_call region, remove
			endif

			;clip local dirty list with parent bounds
			vp_cpy [r4 + draw_view_node], r1
			vp_cpy [r1 + view_parent], r2
			if r2, ==, 0
				vp_cpy r1, r2
			endif
			vp_cpy [r1 + view_x], r8
			vp_cpy [r1 + view_y], r9
			vp_cpy [r2 + view_w], r10
			vp_cpy [r2 + view_h], r11
			vp_mul -1, r8
			vp_mul -1, r9
			vp_add r8, r10
			vp_add r9, r11
			vp_add view_dirty_list, r1
			static_call region, clip

			;paste local dirty list onto global dirty list
			vp_cpy [r4 + draw_view_node], r2
			vp_cpy [r2 + view_ctx_x], r8
			vp_cpy [r2 + view_ctx_y], r9
			vp_lea [r4 + draw_view_patch_list], r2
			static_call region, paste_region

			;free local dirty list
			vp_cpy [r4 + draw_view_node], r1
			vp_lea [r1 + view_dirty_list], r1
			static_call region, free

			;restore node
			vp_cpy [r4 + draw_view_node], r0

			;down to child
			lh_get_head r0 + view_list, r1
			vp_sub view_node, r1
		loop_until qword[r1 + view_node + ln_node_succ], ==, 0
		loop_while r0, !=, [r4 + draw_view_root]
			;across to sibling
			ln_get_succ r0 + view_node, r1
			vp_sub view_node, r1
			jmpif qword[r1 + view_node + ln_node_succ], !=, 0, down_loop_back_to_front

			;up to parent
			vp_cpy [r0 + view_parent], r0
		loop_end

		;iterate through views front to back
		;distribute visible region list
		vp_cpy [r4 + draw_view_root], r1
		loop_start
		down_loop_front_to_back:
			vp_cpy r1, r0

			;down to child
			lh_get_tail r0 + view_list, r1
			vp_sub view_node, r1
		loop_until qword[r1 + view_node + ln_node_pred], ==, 0
		loop_while r0, !=, [r4 + draw_view_root]
			;save node
			vp_cpy r0, [r4 + draw_view_node]

			;if opaque cut view else copy transparent patches
			vp_cpy r0, r3
			vp_cpy [r0 + view_ctx_x], r8
			vp_cpy [r0 + view_ctx_y], r9
			vp_lea [r4 + draw_view_patch_list], r1
			vp_lea [r0 + view_dirty_list], r2
			static_bind gui, statics, r0
			vp_lea [r0 + gui_statics_rect_heap], r0
			if qword[r3 + view_transparent_list], ==, 0
				vp_cpy [r3 + view_w], r10
				vp_cpy [r3 + view_h], r11
				vp_add r8, r10
				vp_add r9, r11
				static_call region, cut
			else
				vp_add view_transparent_list, r3
				static_call region, copy_region
			endif

			;restore node
			vp_cpy [r4 + draw_view_node], r0

			;across to sibling
			ln_get_pred r0 + view_node, r1
			vp_sub view_node, r1
			jmpif qword[r1 + view_node + ln_node_pred], !=, 0, down_loop_front_to_back

			;up to parent
			vp_cpy [r0 + view_parent], r0
		loop_end

		;any remaining patches are root views
		vp_cpy [r4 + draw_view_root], r1
		vp_cpy [r4 + draw_view_patch_list], r0
		vp_cpy r0, [r1 + view_dirty_list]
		vp_cpy 0, qword[r4 + draw_view_patch_list]

		;iterate through views back to front drawing
		vp_cpy [r4 + draw_view_root], r1
		loop_start
		down_loop_draw:
			vp_cpy r1, r0

			;save node
			vp_cpy r0, [r4 + draw_view_node]

			;draw myself
			vp_lea [r4 + draw_view_ctx], r1
			vp_lea [r0 + view_dirty_list], r2
			vp_cpy [r0 + view_ctx_x], r8
			vp_cpy [r0 + view_ctx_y], r9
			vp_cpy r2, [r1 + gui_ctx_dirty_region]
			vp_cpy r8, [r1 + gui_ctx_x]
			vp_cpy r9, [r1 + gui_ctx_y]
			method_call view, draw

			;free local dirty list
			vp_cpy [r4 + draw_view_node], r1
			vp_lea [r1 + view_dirty_list], r1
			static_bind gui, statics, r0
			vp_lea [r0 + gui_statics_rect_heap], r0
			static_call region, free

			;restore node
			vp_cpy [r4 + draw_view_node], r0

			;down to child
			lh_get_head r0 + view_list, r1
			vp_sub view_node, r1
		loop_until qword[r1 + view_node + ln_node_succ], ==, 0
		loop_while r0, !=, [r4 + draw_view_root]
			;across to sibling
			ln_get_succ r0 + view_node, r1
			vp_sub view_node, r1
			jmpif qword[r1 + view_node + ln_node_succ], !=, 0, down_loop_draw

			;up to parent
			vp_cpy [r0 + view_parent], r0
		loop_end

		vp_add draw_view_size, r4
		vp_ret

	fn_function_end
