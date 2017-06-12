def unescape(string)
  YAML.load(%Q(---\n"#{string}"\n))
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  begin
    page.evaluate_script('jQuery.active').zero?
  rescue Capybara::NotSupportedByDriverError
    true
  end
end