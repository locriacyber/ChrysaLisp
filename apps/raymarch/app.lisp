;jit compile apps native functions if needed
(import "lib/asm/asm.inc")
(bind '(_ *cpu* *abi*) (split (load-path) "/"))
(make '("apps/raymarch/lisp.vp") *abi* *cpu*)

;imports
(import "gui/lisp.inc")

(structure '+event 0
	(byte 'close+))

(defun child-msg (mbox &rest _)
	(cat mbox (apply cat (map (# (char %0 (const long_size))) _))))

(defq canvas_width 800 canvas_height 800 canvas_scale 1 then (pii-time)
	area (* canvas_width canvas_height canvas_scale canvas_scale) devices (mail-nodes)
	farm (open-farm "apps/raymarch/child.lisp"
		(min (* 2 (length devices)) (* canvas_height canvas_scale)) kn_call_child devices)
	select (list (task-mailbox) (mail-alloc-mbox))
	jobs (map (lambda (y) (child-msg (elem -2 select)
			0 y (* canvas_width canvas_scale) (inc y)
			(* canvas_width canvas_scale) (* canvas_height canvas_scale)))
		(range (dec (* canvas_height canvas_scale)) -1)))

(ui-window mywindow ()
	(ui-title-bar _ "Raymarch" (0xea19) +event_close+)
	(ui-canvas canvas canvas_width canvas_height canvas_scale))

(defun tile (canvas data)
	; (tile canvas data) -> area
	(defq data (string-stream data) x (read-int data) y (read-int data)
		x1 (read-int data) y1 (read-int data) yp (dec y))
	(while (/= (setq yp (inc yp)) y1)
		(defq xp (dec x))
		(while (/= (setq xp (inc xp)) x1)
			(.-> canvas (:set_color (read-int data)) (:plot xp yp)))
		(task-sleep 0))
	(* (- x1 x) (- y1 y)))

;native versions
(ffi tile "apps/raymarch/tile" 0)

(defun main ()
	;add window
	(.-> canvas (:fill +argb_black+) :swap)
	(bind '(x y w h) (apply view-locate (. mywindow :pref_size)))
	(gui-add (. mywindow :change x y w h))
	;send first batch of jobs
	(each (# (mail-send %0 (pop jobs))) farm)
	;main event loop
	(while (progn
		;next event
		(defq id (mail-select select) msg (mail-read (elem id select)))
		(cond
			((= id 0)
				;main mailbox
				(cond
					((= (setq id (get-long msg ev_msg_target_id)) +event_close+)
						;close button
						nil)
					(t (. mywindow :event msg))))
			(t	;child tile msg
				(if (defq child (slice (dec (neg net_id_size)) -1 msg) next_job (pop jobs))
					;next job
					(mail-send child next_job))
				(setq area (- area (tile canvas msg)))
				(when (= area 0)
					;close farm and clear it
					(each (# (mail-send %0 "")) farm)
					(clear farm))
				(when (or (> (- (defq now (pii-time)) then) 1000000) (= area 0))
					;swap canvas
					(setq then now)
					(. canvas :swap))
					t))))
	;close
	(. mywindow :hide)
	(mail-free-mbox (pop select))
	(each (# (mail-send %0 "")) farm))
