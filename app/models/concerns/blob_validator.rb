# class BlobValidator < ActiveModel::EachValidator
#     def validate_each(record, attribute, values)
#         return unless values.attached?

#         files_sum = ActiveStorage::Attachment.where(record: Directory.all).map(&:byte_size).sum
#         if(files_sum > options[:max_size])
#         Array(values).each do |value|
#             if options[:size_range].present?
#             if options[:size_range].min > value.blob.byte_size
#                 record.errors.add(attribute, :min_size_error, min_size: ActiveSupport::NumberHelper.number_to_human_size(options[:size_range].min))
#             elsif options[:size_range].max < value.blob.byte_size
#                 record.errors.add(attribute, :max_size_error, max_size: ActiveSupport::NumberHelper.number_to_human_size(options[:size_range].max))
#             end
#             end
    
#             unless valid_content_type?(value.blob)
#             record.errors.add(attribute, :content_type)
#             end
#         end
#     end