# -*- coding: utf-8 -*-
require 'spec_helper'

describe LanguageDetector do
  subject { LanguageDetector.new(%w[ja en]) }
  it { should_not be_nil }
end
