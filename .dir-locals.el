;;; This file contains configuration stuff for editing corpus files in Emacs.
((text-mode . ((indent-tabs-mode . t)
               (whitespace-style . (face tabs trailing empty
                                    space-before-tab space-after-tab
                                    tab-mark))
               (whitespace-display-mappings . ((space-mark 32 [183] [46])
                                               (space-mark 160 [164] [95])
                                               (newline-mark 10 [9166 10]
                                                             [182 10]
                                                             [36 10])
                                               (tab-mark 9 [8680 9]
                                                         [8677 9]
                                                         [187 9]
                                                         [92 9])))
               (eval . (whitespace-mode)))))
