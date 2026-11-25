import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_inline_message.dart';
import 'package:retina_scan_app/res/components/app_inner_scaffold.dart';
import 'package:retina_scan_app/res/components/app_text_field.dart';
import 'package:retina_scan_app/res/components/empty_state.dart';
import 'package:retina_scan_app/res/components/person_tile.dart';
import 'package:retina_scan_app/res/components/scan_summary_tile.dart';
import 'package:retina_scan_app/res/components/section_title.dart';
import 'package:retina_scan_app/res/components/suggestion_chips.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/validators.dart';
import 'package:retina_scan_app/view_models/patient/create_request_controller.dart';

/// Last step: the patient tells the story and sends the report to the doctor.
class CreateRequestScreen extends GetView<CreateRequestController> {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel? doctor = controller.doctor;

    if (doctor == null) {
      return const AppInnerScaffold(
        title: AppStrings.requestReviewTitle,
        children: <Widget>[
          EmptyState(
            icon: Icons.person_off_outlined,
            title: AppStrings.doctorNotFound,
            message: AppStrings.doctorNotFoundMsg,
          ),
        ],
      );
    }

    final ThemeData theme = Theme.of(context);

    return AppInnerScaffold(
      title: AppStrings.requestReviewTitle,
      bottom: Obx(
            () => AppButton(
          label: AppStrings.sendRequest,
          icon: Icons.send_rounded,
          isLoading: controller.isLoading.value,
          onPressed: controller.submit,
        ),
      ),
      children: <Widget>[
        const SectionTitle(title: AppStrings.sendingTo),
        10.vSpace,
        PersonTile(name: doctor.name, id: doctor.id, subtitle: doctor.specialty),
        if (controller.scan != null) ...<Widget>[
          20.vSpace,
          const SectionTitle(title: ScanStrings.attachedScan),
          10.vSpace,
          ScanSummaryTile(result: controller.scan!),
        ],
        24.vSpace,
        Form(
          key: controller.formKey,
          child: AppTextField(
            controller: controller.symptomsController,
            label: ScanStrings.storyLabel,
            hint: ScanStrings.storyHint,
            prefixIcon: Icons.edit_note_rounded,
            minLines: 5,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            validator: Validators.symptoms,
          ),
        ),
        14.vSpace,
        Text(
          ScanStrings.quickAdd,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        8.vSpace,
        SuggestionChips(
          items: ScanStrings.symptomChips,
          onTap: controller.addSymptom,
        ),
        Obx(() {
          final String? error = controller.errorMessage.value;
          if (error == null) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(top: 16.sz),
            child: AppInlineMessage(message: error),
          );
        }),
      ],
    );
  }
}