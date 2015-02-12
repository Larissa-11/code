<?php
/**
 * Parameters extension.
 *
 * Read and write parameters to and from database.
 */

if (!defined('MEDIAWIKI')) {
    echo("This is an extension to the MediaWiki package and cannot be run ".
        "standalone.\n");
    die(-1);
}

require_once('FacParameter.php');
require_once('FacTextReplacer.php');

$wgExtensionCredits['other'][] = array(
    'name' => 'Parameters',
    'version' => 0.0,
    'author' => array('Afonso'),
    'url' => 'http://10.0.21.132/',
    'description' => 'Create, edit and include machine parameters'
);

$wgHooks['ParserFirstCallInit'][] = 'fac_parameter_parser_init';
$wgHooks['EditFormPreloadText'][] = 'fac_edit_form_preload_text';
$wgHooks['EditFormInitialText'][] = 'fac_edit_form_initial_text';
$wgHooks['EditFilter'][] = 'fac_edit_filter';
$wgHooks['PageContentSave'][] = 'fac_page_content_save';
$wgHooks['TitleMove'][] = 'fac_title_move';
$wgHooks['AbortMove'][] = 'fac_abort_move';
$wgHooks['ArticleDelete'][] = 'fac_article_delete';

function fac_parameter_parser_init(Parser $parser)
{
    $parser->setHook("sirius", "fac_sirius_parameter_render");
    $parser->setHook("sirius_value", "fac_sirius_value_parameter_render");
    $parser->setHook("sirius_units", "fac_sirius_units_parameter_render");
    $parser->setHook("dependencies", "fac_dependencies_parameter_render");
    $parser->setHook("dependents", "fac_dependents_parameter_render");
    return true;
}

function fac_sirius_parameter_render($input, array $args, Parser $parser,
    PPFrame $frame)
{
    try {
        $prm = new FacParameterReader($input);
        $fields = $prm->read();
        $output = fac_get_sirius_parameter_with_args($fields, $args);
        return $parser->recursiveTagParse($output, $frame);
    } catch(FacException $e) {
        $output = fac_get_error_message('Error: ' . $e->getMessage());
        return $parser->recursiveTagParse($output, $frame);
    }
}

function fac_get_sirius_parameter_with_args($fields, $args)
{
    $field = fac_get_arg_value('field', $args);
    $format = fac_get_arg_value('format', $args);
    $link = fac_get_arg_value('link', $args);

    if ($format)
        $fields['value'] = sprintf($format, $fields['value']);

    if (strtoupper($link) != 'FALSE')
        $fields['value'] = '[[' . FacParameter::parameter_namespace .
            $fields['name'] . '|' . $fields['value'] . ']]';

    if ($field)
        return $fields[$field];
    else
        return $fields['value'] . " " . $fields['units'];

}

function fac_get_arg_value($arg, array $args)
{
    if (array_key_exists($arg, $args))
        return $args[$arg];
    else
        return false;
}

function fac_get_error_message($msg, $bold=true)
{
    if ($bold)
        $s = "'''";
    else
        $s = "";

    return $s . "<span style=\"color: red\">" . $msg . "</span>" . $s;
}

function fac_sirius_value_parameter_render($input, array $args,
    Parser $parser, PPFrame $frame)
{
    $args['field'] = 'value';
    return fac_sirius_parameter_render($input, $args, $parser, $frame);
}

function fac_sirius_units_parameter_render($input, array $args,
    Parser $parser, PPFrame $frame)
{
    $args['field'] = 'units';
    $args['link'] = 'FALSE';
    return fac_sirius_parameter_render($input, $args, $parser, $frame);
}

function fac_dependencies_parameter_render($input, array $args,
    Parser $parser, PPFrame $frame)
{
    try {
        $prm = new FacParameterReader($input);
        $deps = $prm->read_dependencies();
        $deps_with_links = fac_add_link_to_parameters($deps);
        $output = implode(', ', $deps_with_links);
        return $parser->recursiveTagParse($output, $frame);
    } catch(FacException $e) {
        $output = fac_get_error_message('Error: ' . $e->getMessage());
        return $parser->recursiveTagParse($output, $frame);
    }
}

function fac_add_link_to_parameters($parameters)
{
    $result = array();
    foreach ($parameters as $p) {
        $s = '[[' . FacParameter::parameter_namespace . $p . '|' . $p . ']]';
        array_push($result, $s);
    }
    return $result;
}

function fac_dependents_parameter_render($input, array $args, Parser $parser,
    PPFrame $frame)
{
    try {
        $prm = new FacParameterReader($input);
        $deps = $prm->read_dependents();
        $deps_with_links = fac_add_link_to_parameters($deps);
        $output = implode(', ', $deps_with_links);
        return $parser->recursiveTagParse($output, $frame);
    } catch(FacException $e) {
        $output = fac_get_error_message('Error: ' . $e->getMessage());
        return $parser->recursiveTagParse($output, $frame);
    }
}

function fac_edit_form_preload_text(&$text, &$title)
{
    $name = FacParameter::get_name_if_parameter($title);
    if (!$name)
        return true; # not a parameter page

    $text = FacParameter::get_parameter_template($name);
    return true;
}

function fac_edit_form_initial_text($editPage)
{
    $name = FacParameter::get_name_if_parameter($editPage->getTitle());
    if (!$name)
        return true; # not a parameter page

    try {
        $prm = new FacParameterReader($name);
        $fields = $prm->read();
    
        if (strtoupper($fields['is_derived']) != 'TRUE')
            return true;

        $expression = $prm->read_expression();
    } catch(FacException $e) {
        return false;
    }
    
    $text = $editPage->textbox1;
    $replacer = new FacTextReplacer($text);
    $new_text = $replacer->replace_value($expression);

    $editPage->textbox1 = $new_text;

    return true;
}

function fac_edit_filter($editor, $text, $section, &$error, $summary)
{
    $name = FacParameter::get_name_if_parameter($editor->getTitle());
    if (!$name)
        return true; # not a parameter page

    try {
        $prm = new FacParameterWriter($name, $text);
        $result = $prm->write();
        if (!$result)
            $error = fac_get_missing_fields_message($prm->missing_fields);
    } catch (FacException $e) {
        $error = fac_get_error_message('Error: ' . $e->getMessage());
    }

    return true;
}

function fac_get_missing_fields_message($missing_fields)
{
    $msg = "Missing field";
    if (count($missing_fields) > 1)
        $msg .= "s";
    $field_list = htmlspecialchars(implode(', ', $missing_fields));
    $msg .= ": " . $field_list;

    return fac_get_error_message($msg, false);
}

function fac_page_content_save(&$wikiPage, &$user, &$content, &$summary,
    $isMinor, $isWatch, $section, &$flags, &$status)
{
    $name = FacParameter::get_name_if_parameter($wikiPage->getTitle());
    if (!$name)
        return true; # not a parameter page

    try {
        $prm = new FacParameterReader($name);
        $fields = $prm->read();
    } catch(FacException $e) {
        return false;
    }

    if (strtoupper($fields['is_derived']) != 'TRUE')
        return true;

    $text = $content->getNativeData();
    $replacer = new FacTextReplacer($text);
    $new_text = $replacer->replace_value($fields['value']);

    $content = new WikitextContent($new_text);
}

function fac_title_move(Title $title, Title $newTitle, User $user)
{
    $ns = substr(FacParameter::parameter_namespace, 0, -1); # remove colon

    $old_ns = $title->getSubjectNsText();
    $new_ns = $newTitle->getSubjectNsText();

    if(($old_ns != $ns) or ($new_ns != $ns))
        return true; # not in parameter namespace

    try {
        $prm = new FacParameterWriter($title->getText());
        $prm->rename($newTitle->getText());
    } catch(FacException $e) {
        return false;
    }

    return true;
}

function fac_abort_move(Title $oldTitle, Title $newTitle, User $user,
    &$error, $reason)
{
    $ns = substr(FacParameter::parameter_namespace, 0, -1); # remove colon

    if ($oldTitle->getSubjectNsText() != $ns) {
        if ($newTitle->getSubjectNsText() == $ns) {
            $error = 'Cannot move to parameter namespace!';
            return false;
        }
    } else {
        if ($newTitle->getSubjectNsText() != $ns) {
            $error = 'Cannot move out of parameter namespace!';
            return false;
        } else {
            if ($newTitle->exists()) {
                $error = 'Cannot overwrite existing parameter!';
                return false;
            }
        }
    }

    return true;
}

function fac_article_delete(WikiPage &$wikiPage, User &$user, &$reason,
    &$error)
{
    $name = FacParameter::get_name_if_parameter($wikiPage->getTitle());
    if (!$name)
        return true; # not a parameter page

    try {
        $prm = new FacParameterEraser($name);
        $prm->erase();
        return true;
    } catch(FacException $e) {
        $error = fac_get_error_message($e->getMessage(), false);
        return false;
    }
}

?>