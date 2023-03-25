# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, key: '_bulletins65_session',
                                                      expire_after: 1.month,
                                                      domain: :all,
                                                      same_site: :lax
