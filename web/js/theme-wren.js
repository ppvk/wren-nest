ace.define("ace/theme/wren",["require","exports","module","ace/lib/dom"], function(require, exports, module) {

exports.isDark = false;
exports.cssClass = "ace-wren";
exports.cssText = ".ace-wren .ace_gutter {\
background: #F9FAFB;\
color: #52667a\
}\
.ace-wren .ace_print-margin {\
width: 1px;\
background: #F9FAFB\
}\
.ace-wren {\
background-color: #F9FAFB;\
color: #52667a\
}\
.ace-wren .ace_cursor {\
color: #AEAFAD\
}\
.ace-wren .ace_marker-layer .ace_selection {\
background: #D6D6D6\
}\
.ace-wren.ace_multiselect .ace_selection.ace_start {\
box-shadow: 0 0 3px 0px #FFFFFF;\
}\
.ace-wren .ace_marker-layer .ace_step {\
background: rgb(255, 255, 0)\
}\
.ace-wren .ace_marker-layer .ace_bracket {\
margin: -1px 0 0 -1px;\
border: 1px solid #D1D1D1\
}\
.ace-wren .ace_marker-layer .ace_active-line {\
background: rgba(0,0,0,0.05)\
}\
.ace-wren .ace_gutter-active-line {\
background-color : rgba(0,0,0,0.08)\
}\
.ace-wren .ace_marker-layer .ace_selected-word {\
border: 1px solid #D6D6D6\
}\
.ace-wren .ace_invisible {\
color: #D1D1D1\
}\
.ace-wren .ace_keyword,\
.ace-wren .ace_meta,\
.ace-wren .ace_storage,\
.ace-wren .ace_storage.ace_type,\
.ace-wren .ace_support.ace_type {\
color: hsl(210, 80%, 60%)\
}\
.ace-wren .ace_keyword.ace_operator {\
color: #52667a\
}\
.ace-wren .ace_constant.ace_character,\
.ace-wren .ace_constant.ace_language,\
.ace-wren .ace_constant.ace_numeric,\
.ace-wren .ace_keyword.ace_other.ace_unit,\
.ace-wren .ace_support.ace_constant,\
.ace-wren .ace_variable.ace_parameter {\
color: #59a112\
}\
.ace-wren .ace_constant.ace_other {\
color: #666969\
}\
.ace-wren .ace_invalid {\
color: #FFFFFF;\
background-color: #C82829\
}\
.ace-wren .ace_invalid.ace_deprecated {\
color: #FFFFFF;\
background-color: #8959A8\
}\
.ace-wren .ace_fold {\
background-color: #4271AE;\
border-color: #4D4D4C\
}\
.ace-wren .ace_entity.ace_name.ace_function,\
.ace-wren .ace_support.ace_function,\
.ace-wren .ace_variable {\
color: #4271AE\
}\
.ace-wren .ace_support.ace_class,\
.ace-wren .ace_support.ace_type {\
color: #C99E00\
}\
.ace-wren .ace_heading,\
.ace-wren .ace_markup.ace_heading,\
.ace-wren .ace_string {\
color: #e6a21a\
}\
.ace-wren .ace_entity.ace_name.ace_tag,\
.ace-wren .ace_entity.ace_other.ace_attribute-name,\
.ace-wren .ace_meta.ace_tag,\
.ace-wren .ace_string.ace_regexp,\
.ace-wren .ace_variable {\
color: #C82829\
}\
.ace-wren .ace_comment {\
color: #95a1ae\
}\
.ace-wren .ace_indent-guide {\
background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAACCAYAAACZgbYnAAAAE0lEQVQImWP4////f4bdu3f/BwAlfgctduB85QAAAABJRU5ErkJggg==) right repeat-y\
}";

var dom = require("../lib/dom");
dom.importCssString(exports.cssText, exports.cssClass);
});
